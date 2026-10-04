# Tide pads every prompt item with a space on both sides. The OS icon is drawn
# two cells wide and already fills the cell after it, so with that padding it
# sits off-centre. Print it without the padding instead; the single trailing
# space is the cell the icon spills into.
#
# This lives in conf.d (not config.fish) because Tide renders the prompt in a
# non-interactive background shell.
function _tide_item_os
    _tide_pad= _tide_print_item os $tide_os_icon' '
end
