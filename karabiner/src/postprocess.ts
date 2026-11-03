// Post-process karabiner.json so long HRM holds don't type the letter on
// release (QMK/Vial parity). Karabiner's to_if_alone fires the tap even when
// to_if_held_down already fired the modifier; QMK hold-tap produces nothing
// on release after the tapping term. For each HRM layer key:
//   - keydown resets the "held" flag
//   - the hold action sets the flag
//   - the tap (to_if_alone) is suppressed when the flag is set
import { readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";

const profilePath = `${homedir()}/.config/karabiner/karabiner.json`;
const profile = JSON.parse(readFileSync(profilePath, "utf8"));
const hrm = profile.profiles[0].complex_modifications.rules.find(
  (r: any) => r.description === "Home row mods",
);
if (!hrm) throw new Error("Home row mods rule not found");

let patched = 0;
for (const m of hrm.manipulators) {
  if (!m.from?.key_code || !m.to_if_alone || !m.to_if_held_down) continue;
  const startSet = (m.to ?? []).find((e: any) =>
    e.set_variable?.name?.endsWith("-start"),
  );
  if (!startSet) continue; // not an HRM layer config manipulator
  const heldVar = startSet.set_variable.name.replace(/-start$/, "-held");
  // reset on keydown
  m.to.push({ set_variable: { name: heldVar, value: 0 } });
  // flag when the hold fires (set_variable events must precede the modifier)
  m.to_if_held_down.unshift({ set_variable: { name: heldVar, value: 1 } });
  // suppress the tap if the hold fired
  m.to_if_alone = m.to_if_alone.map((e: any) => ({
    ...e,
    conditions: [
      ...(e.conditions ?? []),
      { type: "variable_unless", name: heldVar, value: 1 },
    ],
  }));
  patched++;
}
writeFileSync(profilePath, `${JSON.stringify(profile, null, 4)}\n`);
console.log(`patched ${patched} HRM layer keys`);