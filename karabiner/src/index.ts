// Aligned to vial/corne-keymap.vil (combos, nav, home row mods)
import {
  ifDevice,
  map,
  mapSimultaneous,
  rule,
  writeToProfile,
  type Manipulator,
} from "karabiner.ts";
import { capsWord, hrm, holdTapLayer } from "karabiner.ts-greg-mods";

const builtIn = ifDevice({ is_built_in_keyboard: true });

/** Drop mouse-button rules so Karabiner need not start VirtualHIDPointing. */
function withoutPointing(manipulators: Manipulator[]): Manipulator[] {
  return manipulators.filter((m) => {
    const from = (m as { from?: { pointing_button?: unknown } }).from;
    return !(from && "pointing_button" in from);
  });
}

// Keys with no nav mapping replay as themselves, so a fast space roll with
// them never eats the space (don't|r → don'tre).
const identityReplayKeys = [
  "b", "e", "m", "n", "o", "p", "q", "r", "t", "w", "x", "y", "z",
  "semicolon", "comma", "period",
];

writeToProfile("Default", [
  // Combos: order and set match corne-keymap.vil
  rule("Combos")
    .condition(builtIn)
    .manipulators([
      mapSimultaneous(["q", "w"], { key_up_when: "any" }).to("escape"),
      mapSimultaneous(["z", "x"], { key_up_when: "any" }).to("tab"),
      mapSimultaneous(["j", "k", "l"], { key_up_when: "any" }).to(
        "return_or_enter",
      ),
      mapSimultaneous(["f", "j", "k", "l"], { key_up_when: "any" }).to(
        "return_or_enter",
        "command",
      ),
      mapSimultaneous(["a", "j", "k", "l"], { key_up_when: "any" }).to(
        "return_or_enter",
        "shift",
      ),
      mapSimultaneous(["j", "l"], { key_up_when: "any" }).to(
        "delete_or_backspace",
      ),
      mapSimultaneous(["l", ";"], { key_up_when: "any" }).to(
        "delete_or_backspace",
      ),
      mapSimultaneous(["j", "k"], { key_up_when: "any" }).to(
        "left_arrow",
        "option",
      ),
      mapSimultaneous(["k", "l"], { key_up_when: "any" }).to(
        "right_arrow",
        "option",
      ),
    ]),

  holdTapLayer("spacebar")
    // Nav actions fire as soon as the key is tapped while space is held
    // (space↓ key↓ key↑), no need to hold out the tapping term.
    .permissiveHoldManipulators(
      map("h").to("left_arrow"),
      map("j").to("down_arrow"),
      map("k").to("up_arrow"),
      map("l").to("right_arrow"),
      map("u").to("page_down"),
      map("i").to("page_up"),
      map("c").to("open_bracket", ["command", "shift"]),
      map("v").to("close_bracket", ["command", "shift"]),
      map("a").to("a", "option"),
      map("s").to("s", "option"),
      map("d").to("d", "option"),
      map("f").to("f", "option"),
      map("g").to("g", "option"),
    )
    // Keys with no nav mapping still replay slowly so typing rolls never
    // lose the space.
    .slowManipulators(
      ...identityReplayKeys.map((k) => map(k as never).to(k as never)),
    )
    .tappingTerm(175)
    .description("Nav layer")
    .build(),

  rule("Disable Cmd+H").manipulators([
    map("h", "command").to("vk_none"),
    map("m", "command").to("vk_none"),
  ]),

  capsWord()
    .toggle(
      mapSimultaneous(["a", ";"], { key_up_when: "any" })
        .condition(builtIn)
        .build()[0],
    )
    .build(),

  rule("Home row mods")
    .condition(builtIn)
    .manipulators(
withoutPointing(
        hrm(
          new Map([
            ["a", "left_shift"],
            ["s", "left_control"],
            ["d", "left_option"],
            ["f", "left_command"],
            [";", "right_shift"],
            ["j", "right_command"],
            ["k", "right_option"],
            ["l", "right_control"],
          ]),
        )
          .lazy(true)
          .triples(false)
          .holdTapStrategy("permissive-hold")
          // roll-safety for the two combos seen misfiring live:
          // d+u ("dude" -> "¨de") and a+l ("really" -> "reLly")
          .keys("left_option", ["u"], "slow")
          .keys("left_shift", ["l"], "slow")
          .tappingTerm(300)
          .build(),
      ),
    ),
]);
