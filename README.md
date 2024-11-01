# TheSkyLib
A tool with Python Scripts useful for owners of Skylanders™.

### How to Use:

1. Download **[TheSkyLib](https://github.com/DevZillion/TheSkyLib/archive/refs/heads/main.zip)**.
  - _The link will download a "**TheSkyLib-main.zip**" file. Extract it somehwere and remember the location._
2. Download and install **[Python](https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe)**.
3. You need to export your empty NFC tag to a .dump file.
  - _If you are on **Android**, watch this **[video](https://www.youtube.com/watch?v=hhT0tAHdcMc)**_.
  - _If you are on **Windows** with **ACR122U**, open "**[Mifare Windows Tool v1.6](https://github.com/ElDavoo/Mifare-Windows-Tool-Reborn)**_"
  - _Place an **empty tag** on the **ACR122U** reader_.
  - _Inside **Mifare Windows Tool v1.6**, click on "**READ TAG**_"
  - _Select "**std.keys**" and click on "**Start Decode & Read tag**"._
  - _Wait a moment. If you receive any warnings, unplug and plug the USB cable of the reader back in, then try again_.
  - _When done, you should see a popup window, with repeating green FFFFFFFFFFFF keys and a lot of white 0_.
  - _At the bottom of this window, click on "**Save Dump as**"_.
  - _Give it a name that you would recognize (mine will be **Empty_Tag_1**). Don't manually type file extensions. MWT will add .dump extension for you._
  - _Now this newly created "**Empty_Tag_1.dump**" file is your empty card dump. You will need it for "**TheSkyLib**" software_.
4. Open "**TheSkyLib-main**" folder from **Step 1**.
5. Go inside "**dumps\blank_tags**" and place your "**Empty_Tag_1.dump**" there.
6. Go inside "**dumps\skylanders**" and place your **desired Skylanders dumps** there.
  - _You can get those from the **[Skylanders Ultimate NFC Pack](https://skylandersnfc.github.io/Skylanders-Ultimate-NFC-Pack/)**_
7. Go back to the main "**TheSkyLib-main**" folder and double click "**Dump2LockedTag.bat**"
8. You should see smomething like this:

> File List:
> 
> Empty_Tag_1.dump
> 
> Put the dump of the tags you want to write here
> 
> ~~> [With extensions] Write the name of your BLANK TAG .dump/.dmp/.sky/.bin file:

9. Type the name of your empty tag. In our example "**Empty_Tag_1.dump**"
10. Then you should see something like this:

> File List:
> 
> Bash.dump
> 
> Put the dump of the skylanders you want to write here
> 
> ~~> [With extensions] Write the name of your SKYLANDER .dump/.dmp/.sky/.bin file:

11. Type the name if your Skylander dump. In our example **"Bash.dump"**
12. Then you should see something like this:
    
> ~~> [Without extensions] Write the name desired for your output .dump file:

13. Type the name of your output dump **without the extension**. In this case I will name it "**Bash_Modified_for_Card_1**"
  - _Here you can also use the card **UID** as part of the name. For example "**Bash_0F51DF64**"_.
15. Wait a second, you will see how to screen changes and will show you some keys and then auto close.
16. Go to "**output\Dump2LockedTag**" folder.
  - _Here you should see the generated "**Bash_Modified_for_Card_1.dump**" or however you have named it._
16. Now use this new generated NFC dump to write it onto the same card from which you extracted the empty dump initially."
  - _Don't write it to other cards, as it won't work._
  - _You need to follow this process for each different UID-locked card._
  - _You will still write 63 out of 64 blocks with MWT. That's alright._

### Special thanks to:
>[Vitorio Miliano](http://) - [libs/tnp3xxx.py](https://github.com/DevZillion/TheSkyLib/blob/main/libs/tnp3xxx.py)
>
>[Toni Cunyat](https://github.com/elbuit) - [libs/sklykeys.py](https://github.com/DevZillion/TheSkyLib/blob/main/libs/sklykeys.py)
>
>[Nitrus](https://github.com/Nitrus) - [libs/UID.py](https://github.com/DevZillion/TheSkyLib/blob/main/libs/UID.py)
