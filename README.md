## Dzen2/Lemonbar script

![Alt text](https://image.ibb.co/dTyuHp/2018_08_31_101003_1366x768_scrot.png)

Script for a nice bar to run through Dzen2 or Lemonbar it shows: uptime, cpu usage, 
memory and swap usage, wifi info, network traffic, volume info, current keyboard 
layout (you have to install xkblayout-state first), music info using Playerctl and a 
clock.

Preferred to run with a small Monospace font (to avoid a lot of resizing).

here's my current dzen2 config for it:
```
(bash ~/.config/scripts/lemonbar.sh | dzen2 -dock -ta l -fg '#ffffff' -e 
'onstart=uncollapse;key_Escape=ungrabkeys,exit' -fn 
'-*-mono-*-*-*-*-10-*-*-*-*-*-*-*' )&
```
or you could use it with Lemonbar:
```
bash ~/.config/scripts/lemonbar.sh | lemonbar
```

