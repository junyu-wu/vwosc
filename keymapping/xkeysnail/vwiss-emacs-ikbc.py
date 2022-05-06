# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# define timeout for multipurpose_modmap
define_timeout(1)

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    # Key.CAPSLOCK: Key.LEFT_CTRL,
    # Key.LEFT_CTRL: Key.CAPSLOCK,
    Key.BACKSPACE: Key.BACKSLASH,
    Key.BACKSLASH: Key.BACKSPACE,
})

# [Conditional modmap] Change modifier keys in certain applications
# define_conditional_modmap(re.compile(r'Emacs'), {
# Key.RIGHT_CTRL: Key.ESC,
# })

# [Multipurpose modmap] Give a key two meanings. A normal key when pressed and
# released, and a modifier key when held down with another key. See Xcape,
# Carabiner and caps2esc for ideas and concept.
# define_multipurpose_modmap(
# Enter is enter when pressed and released. Control when held down.
# {Key.ENTER: [Key.ENTER, Key.RIGHT_CTRL]}

# Capslock is escape when pressed and released. Control when held down.
# {Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL]
# To use this example, you can't remap capslock with define_modmap.
# )

# [Conditional multipurpose modmap] Multipurpose modmap in certain conditions,
# such as for a particular device.
# define_conditional_multipurpose_modmap(lambda wm_class, device_name: device_name.startswith("Microsoft"), {
# Left shift is open paren when pressed and released.
# Left shift when held down.
# Key.LEFT_SHIFT: [Key.KPLEFTPAREN, Key.LEFT_SHIFT],

# Right shift is close paren when pressed and released.
# Right shift when held down.
# Key.RIGHT_SHIFT: [Key.KPRIGHTPAREN, Key.RIGHT_SHIFT]
# })

# Keybindings for Firefox/Chrome
define_keymap(
    re.compile("Firefox|Google-chrome|Chromium-browser"),
    {
        # Type C-j to focus to the content
        K("C-M-TAB"):
        K("C-Shift-TAB"),
        K("C-j"):
        K("C-f6"),
        K("C-q"):
        K("C-w"),
        K("C-r"):
        K("f5"),
        K("C-m"):
        K("C-Shift-b"),
        # very naive "Edit in editor" feature (just an example)
        K("C-c"):
        [K("C-c"),
         launch(["emacs"]),
         sleep(0.5),
         K("C-v")],
        K("C-o"):
        [K("C-a"), K("C-c"),
         launch(["emacs"]),
         sleep(0.5),
         K("C-v")]
    },
    "Firefox and Chrome")

# Keybindings for Zeal https://github.com/zealdocs/zeal/
define_keymap(
    re.compile("Zeal"),
    {
        K("C-s"): K("C-k"),
    },
    "Zeal")

define_keymap(
    re.compile("Vmware"),
    {
        K("C-M-m"): K("M-home"),
        K("C-M-dot"): K("C-page_down"),
        K("C-M-comma"): K("C-page_up"),
        K("C-M-g"): K("C-g"),
    },
    "Vmware")

define_keymap(
    re.compile("calibre"),
    {
        K("C-s"): K("M-Shift-f"),
        K("C-x"): {
            K("C-c"): K("M-f4"),
            K("c"): K("M-f4"),
        },
    },
    "Calibre")

define_keymap(
    re.compile("wpsoffice"),
    {
        # Cursor
        K("C-b"):
        with_mark(K("left")),
        K("C-f"):
        with_mark(K("right")),
        K("C-p"):
        with_mark(K("up")),
        K("C-n"):
        with_mark(K("down")),
        # Forward/Backward word
        K("M-b"):
        with_mark(K("C-left")),
        K("M-f"):
        with_mark(K("C-right")),
        # Beginning/End of line
        K("C-a"):
        with_mark(K("home")),
        K("C-e"):
        with_mark(K("end")),
        # Page up/down
        K("M-v"):
        with_mark(K("page_up")),
        K("C-v"):
        with_mark(K("page_down")),
        # Beginning/End of file
        K("M-Shift-comma"):
        with_mark(K("C-home")),
        K("M-Shift-dot"):
        with_mark(K("C-end")),
        # Copy
        K("C-w"): [K("C-x"), set_mark(False)],
        K("M-w"): [K("C-c"), set_mark(False)],
        K("C-y"): [K("C-v"), set_mark(False)],
        # Delete
        K("C-d"): [K("delete"), set_mark(False)],
        K("M-d"): [K("C-delete"), set_mark(False)],
        # Kill line
        K("C-k"): [K("Shift-end"), K("C-x"),
                   set_mark(False)],
        # Undo
        K("C-slash"): [K("C-z"), set_mark(False)],
        K("C-Shift-ro"):
        K("C-z"),
        # Mark
        K("C-space"):
        set_mark(True),
        K("C-M-space"):
        with_or_set_mark(K("C-right")),
        # Search
        K("C-s"):
        K("F3"),
        K("C-r"):
        K("Shift-F3"),
        K("M-Shift-key_5"):
        K("C-h"),
        # Cancel
        K("C-g"): [K("esc"), set_mark(False)],
        # Escape
        K("C-q"):
        escape_next_key,
        # C-x YYY
        K("C-x"): {
            # C-x h (select all)
            K("h"): [K("C-home"), K("C-a"),
                     set_mark(True)],
            # C-x C-f (open)
            K("C-f"): K("C-o"),
            K("f"): K("C-o"),
            # C-x C-s (save)
            K("C-s"): K("C-s"),
            K("s"): K("C-s"),
            # C-x C-c (exit)
            K("C-c"): K("M-f4"),
            K("c"): K("M-f4"),
            # cancel
            K("C-g"): pass_through_key,
            K("g"): pass_through_key,
            # C-x u (undo)
            K("u"): [K("C-z"), set_mark(False)],
        }
    },
    "Calibre")

define_keymap(
    re.compile("XTerm"),
    {
        # Cursor
        K("C-p"):
        with_mark(K("up")),
        K("C-n"):
        with_mark(K("down")),

        # Cancel
        # K("C-g"): [K("esc"), set_mark(False)],
    },
    "XTerm")

define_keymap(
    re.compile("Emacs"),
    {
        # Cursor
        K("C-p"):
        with_mark(K("up")),
        K("C-n"):
        with_mark(K("down")),
    },
    "Emacs")

# Emacs-like keybindings in non-Emacs applications
define_keymap(
    lambda wm_class: wm_class not in
    ("Emacs", "qterminal", "XTerm", "Mate-terminal", "Vmware"),
    {
        # Cursor
        K("C-b"):
        with_mark(K("left")),
        K("C-f"):
        with_mark(K("right")),
        K("C-p"):
        with_mark(K("up")),
        K("C-n"):
        with_mark(K("down")),
        # K("C-h"): with_mark(K("backspace")),
        # Forward/Backward word
        K("M-b"):
        with_mark(K("C-left")),
        K("M-f"):
        with_mark(K("C-right")),
        # Beginning/End of line
        K("C-a"):
        with_mark(K("home")),
        K("C-e"):
        with_mark(K("end")),
        # Page up/down
        K("M-v"):
        with_mark(K("page_up")),
        K("C-v"):
        with_mark(K("page_down")),
        # Beginning/End of file
        K("M-Shift-comma"):
        with_mark(K("C-home")),
        K("M-Shift-dot"):
        with_mark(K("C-end")),
        # Newline
        K("C-m"):
        K("enter"),
        K("C-j"):
        K("enter"),
        K("C-o"): [K("enter"), K("left")],
        # Copy
        K("C-w"): [K("C-x"), set_mark(False)],
        K("M-w"): [K("C-c"), set_mark(False)],
        K("C-y"): [K("C-v"), set_mark(False)],
        # Delete
        K("C-d"): [K("delete"), set_mark(False)],
        K("M-d"): [K("C-delete"), set_mark(False)],
        # Kill line
        K("C-k"): [K("Shift-end"), K("C-x"),
                   set_mark(False)],
        # Undo
        K("C-slash"): [K("C-z"), set_mark(False)],
        K("C-Shift-ro"):
        K("C-z"),
        # Mark
        K("C-space"):
        set_mark(True),
        K("C-M-space"):
        with_or_set_mark(K("C-right")),
        # Search
        K("C-s"):
        K("F3"),
        K("C-r"):
        K("Shift-F3"),
        K("M-Shift-key_5"):
        K("C-h"),
        # Cancel
        K("C-g"): [K("esc"), set_mark(False)],
        # Escape
        K("C-q"):
        escape_next_key,
        # C-x YYY
        K("C-x"): {
            # C-x h (select all)
            K("h"): [K("C-home"), K("C-a"),
                     set_mark(True)],
            # C-x C-f (open)
            K("C-f"): K("C-o"),
            K("f"): K("C-o"),
            # C-x C-s (save)
            K("C-s"): K("C-s"),
            K("s"): K("C-s"),
            # C-x C-c (exit)
            K("C-c"): K("M-f4"),
            K("c"): K("M-f4"),
            # cancel
            K("C-g"): pass_through_key,
            K("g"): pass_through_key,
            # C-x u (undo)
            K("u"): [K("C-z"), set_mark(False)],
        }
    },
    "Emacs-like keys")
