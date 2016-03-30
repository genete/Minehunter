# Minehunter
A Minesweeper clone made with Godotengine

## Usage
It works basically like the original Minesweeper:
* Left clic over non flagged closed tile, opens it.
* Right clic over closed tile shifts from blanck, to flagged to question.
* Open a tile with no bombs around triggers recursively to open the tiles around it.
* Left clic on a open tile checks whether the flags around matches the number of bombs around and if so, open the rest of closed tiles around. If a misflagged tile exists, the a bomb can be opened and explode.

##TODO
* Change smile face when loose or win game.
* Fix alignement of header to be always centered with the tiles and not with the window size.
* Fix width, height and bombs text entries to be smaller.
* Improve style of text labels and text entries

##Screenshots
!(https://github.com/genete/Minehunter/blob/master/sreen_captures/Screen_capture_10x10x15.png)
!(https://github.com/genete/Minehunter/blob/master/sreen_captures/Screen_capture_10x20x25.png
