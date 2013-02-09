# encoding: utf-8

require 'curses'
require './life_game'
include Curses

WIDTH = 30
HEIGHT = 20

life = LifeGame.new(HEIGHT, WIDTH)

begin
  win = Window.new(HEIGHT,WIDTH,0,0)
  loop do
    win.clear
    win.setpos(0,0)

    life.map.each_with_index do |line, ypos|
      line.each_with_index do |elem, xpos|
        setpos(ypos,xpos)
        if elem == 1
          win.addstr("x")
        else
          win.addstr(" ")
        end
      end
    end
    win.box(?|,?-,?*)
    win.refresh
    sleep 0.5
    life.update
  end
ensure
  close_screen
end
