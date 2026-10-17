"""Write the minimal-NTP settings into a closed Brave profile.
usage: python3 ntp-prefs.py <user-data-dir> [background-file-name]"""
import json, sys, os
root = sys.argv[1]
bg = sys.argv[2] if len(sys.argv) > 2 else None

prefs_path = os.path.join(root, "Default", "Preferences")
p = json.load(open(prefs_path))
ntp = p.setdefault("brave", {}).setdefault("new_tab_page", {})
ntp.update({
    "show_clock": False,
    "show_brave_news": False,
    "show_rewards": False,
    "show_together": False,
    "show_brave_vpn": False,
    "show_branded_background_image": False,
    "show_sponsored_sites": False,
    "show_stats": True,
    "hide_all_widgets": False,
})
if bg:
    ntp.update({
        "show_background_image": True,
        "custom_background_enabled": True,
        "custom_background_image_list": [bg],
        "background": {"type": "custom_image", "selected_value": bg, "random": False},
    })
search = p["brave"].setdefault("brave_search", {})
search["show-ntp-search"] = False
search["show-ntp-chat"] = False
p.setdefault("ntp", {})["shortcust_visible"] = False

# No bookmarks: no bar (on the new tab page or anywhere) and no star button.
b = p["brave"]
b["always_show_bookmark_bar_on_ntp"] = False
b["show_bookmarks_button"] = False
p.setdefault("bookmark_bar", {})["show_on_all_tabs"] = False

# Vertical tabs on the left, without the extra title strip on top.
tabs = b.setdefault("tabs", {})
tabs["vertical_tabs_enabled"] = True
tabs["vertical_tabs_show_title_on_window"] = False

# Right side: no sidebar, no wallet / Leo / rewards / side-panel buttons.
b.setdefault("sidebar", {})["sidebar_show_option"] = 3  # never
b.setdefault("wallet", {})["show_wallet_icon_on_toolbar"] = False
b.setdefault("ai_chat", {})["show_toolbar_button"] = False
b.setdefault("rewards", {})["show_brave_rewards_button_in_location_bar"] = False
b["show_brave_rewards_button"] = False
b["show_side_panel_button"] = False
json.dump(p, open(prefs_path, "w"))

ls_path = os.path.join(root, "Local State")
ls = json.load(open(ls_path))
ls.setdefault("brave", {}).setdefault("p3a", {})["notice_acknowledged"] = True
json.dump(ls, open(ls_path, "w"))
print("written", prefs_path)
