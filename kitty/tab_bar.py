from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, TabBar
from kitty.tabs import TabManager
from kitty.boss import get_boss
import time
import os

# Global list to store the current state of each tab
current_tabs_state = []

# Separate list to keep track of the previous state for comparison
previous_tabs_state = []

def send_command():
    os.system('/opt/homebrew/bin/sketchybar --trigger tabs_changed INFO=kitty')

mark_tab_bar_dirty_org = TabManager.mark_tab_bar_dirty
def my_mark_tab_bar_dirty(self) -> None:
    global current_tabs_state, previous_tabs_state

    mark_tab_bar_dirty_org(self)
 
    current_tabs_state = []
    for idx, tab in enumerate(self.tabs):
        current_tabs_state.append({'title': tab.title, 'is_active': idx == self.active_tab_idx })

    # print("old: ")
    # __import__('pprint').pprint(previous_tabs_state)
    # print("new: ")
    # __import__('pprint').pprint(current_tabs_state)

    # Check if there's any change between the current and previous states of all tabs
    if current_tabs_state != previous_tabs_state:
        previous_tabs_state = current_tabs_state.copy()
        send_command()

# Monkey-patch TabManager to get a hook without showing tab-bar
setattr(TabManager, 'mark_tab_bar_dirty', my_mark_tab_bar_dirty)

# No-op just not break the contract
def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    return screen.cursor.x

