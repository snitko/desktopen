# desktopen
A simple CLI util to open and position X windows.

Everytime a start a computer I had to manually open all my windows: terminal, text editor, browser -
then put them in proper viewports/displayes and position them. This is tedious work to be avoided.
Now I just use the following script made possible by `desktopen`:

A rather simple script that opens and places various X windows on different viewports and desktops for you.

    # Chats and email
    desktopen "google-chrome --new-window https://gmail.com" -v 1 --fullscreen
    desktopen "google-chrome --new-window https://web.telegram.org" -v 1 -d 2 -x 447 -y 50 -w 1569 -h 1256

    # Corporate chats and issue tracking
    desktopen "google-chrome --new-window https://workflowy.com" -v 2 -d 1 -x 3 -y 10 -w 1238 -h 1336
    desktopen "google-chrome --new-window https://mycompany.slack.com/messages/general/" -v 2 -d 1 -x 1269 -y 10 -w 1247 -h 1348
    desktopen "google-chrome --new-window https://mycompany.atlassian.net/issues/" -v 2 -d 2 -x 3 -y 10 -w 1238 -h 1336

    # Coding
    desktopen 'terminator -m -l "project 1"'  -v 6 -d 2 --fullscreen
    desktopen 'gvim -c "cd ~/Work/project-1"' -v 6 -d 1 --fullscreen
    desktopen 'terminator -m -l "project 2"'  -v 6 -d 2 --fullscreen
    desktopen 'gvim -c "cd ~/Work/project-2"' -v 6 -d 1 --fullscreen

To get a detailed breadkdown of all CLI options, just type `desktopen --help` once you installed it.

## Installation
`gem install dekstopen`

## Known issues
* It currently only supports up to 2 displays. Ideally, I'd want it to work with more than 2 monitors, but because I have 2,
I didn't bother to properly adjust the script.
