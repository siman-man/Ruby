require 'curses'
include Curses

init_screen
begin
    win = Window.new(30,100,0,0)
    5.times do |count|
        win.clear
        win.setpos(2,2)
        win.box(?|,?-,?*)
        win.addstr("Sub window #{count}")
        win.refresh
        sleep 1.0
    end
ensure
    close_screen
end
