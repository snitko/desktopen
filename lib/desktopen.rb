def current_screen_resolution
  @current_screen_resolution ||= `xrandr`.split("\n").first.match(/current (\d+) x (\d+),/)[1..2].map(&:to_i)
end

def full_desktop_resolution
  return @full_desktop_resolution if @full_desktop_resolution
  @full_desktop_resolution = []
  `wmctrl -d`.split("\n").each do |line|
    if line.match(/\* DG/)
      @full_desktop_resolution = line.match(/\* DG: (\d+)x(\d+)/)[1..2].map(&:to_i)
      break;
    end
  end
  @full_desktop_resolution
end

def viewports_matrix
  return @viewports_matrix if @viewports_matrix 
  columns = full_desktop_resolution[0]/current_screen_resolution[0]
  rows    = full_desktop_resolution[1]/current_screen_resolution[1]
  { columns: columns, rows: rows }
end

def viewports_coordinates
  return @viewports_coordinates if @viewports_coordinates
  @viewports_coordinates = []

  x,y = current_screen_resolution

  viewports_matrix[:rows].times do |ri|
    viewports_matrix[:columns].times do |ci|
      @viewports_coordinates << [x*ci, y*ri]
    end
  end
  @viewports_coordinates
end

def get_absolute_coordrinates_for_viewport(viewport, x, y)
  viewport_x = viewports_coordinates[viewport-1].first
  viewport_y = viewports_coordinates[viewport-1].last
  [viewport_x + x, viewport_y + y]
end

def position_and_resize_active_window(window_id:, x:, y:, w:, h:, viewport:, display: nil, fullscreen: nil)
  if fullscreen
    #display = y
    x, y = get_absolute_coordrinates_for_viewport(viewport.to_i, 10, 10)
    `wmctrl -i -r #{window_id} -e "0,#{x},#{y},700,500"`
    unless maximized?(window_id)
      `wmctrl -i -r #{window_id} -b toggle,maximized_vert,maximized_horz`
    end
  else
    x, y = get_absolute_coordrinates_for_viewport(viewport.to_i, x.to_i, y.to_i)
    # Unmaximize first
    if maximized?(window_id)
      `wmctrl -i -r #{window_id} -b toggle,maximized_vert,maximized_horz`
    end
    `wmctrl -i -r #{window_id} -e "0,#{x.to_i},#{y.to_i},#{w.to_i},#{h.to_i}"`
  end

  # Moving to screen 2
  move_to_screen_on_the_right(window_id, x.to_i, y.to_i) if display.to_i == 2
end

def maximized?(window_id)
  `xwininfo -all -id #{window_id} | grep Maximized`.split("\n").size == 2
end

def window_ids_list
  `wmctrl -l`.split("\n").map { |line| line.gsub(/\s.*\Z/, '') }
end

def find_opened_window(old_window_ids_list)
  new_windows = window_ids_list - old_window_ids_list
  if @find_window_by_pid_attempt < 50 && new_windows.empty?
    sleep(0.1)
    @find_window_by_pid_attempt += 1
    find_opened_window(old_window_ids_list)
  else
    new_windows.last
  end
end

# Moves window to another screen (in case you have two monitors, for example).
# Currently doesn't support more than that because I don't personally need it
# and it complicates things quite a bit.
def move_to_screen_on_the_right(window_id, current_x, current_y)
  window_id = window_id.sub('0x', '').to_i(16) # converting to dec
  `/usr/bin/xdotool windowmove #{window_id} #{current_x + @current_screen_resolution[0]/2} #{current_y}`
end

