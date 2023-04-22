#!/bin/sh

#mkdir "$XDG_CONFIG_HOME/tg-post"
if [ "$1" = "" ]
then
   echo "Usage: tg-post [file]"
   echo "Options:"
   echo "--channel @channelname - channel for posting"
   echo "--caption - caption to post"
   echo "--token - bot:token"
   echo "--saveconfig - save channel and token"
else
    token=$(cat "$XDG_CONFIG_HOME"/tg-post/token.txt)
    file="$1"
    shift
    caption=""
    saveconfig=false
    channel=$(cat "$XDG_CONFIG_HOME"/tg-post/channel.txt)
    
    while [ $# -gt 0 ]; do
        case $1 in
            --channel)
              channel="$2"
              shift
              shift
              ;;
            '--caption')
              caption=$2
              shift
              shift
              ;;
            --token)
              token="$2"
              shift
              shift
              ;;
            --saveconfig)
              saveconfig=true
              shift
              ;;
            -*|--*)
              echo "Unknown option $1"
              exit 1
              ;;
        esac
    done
    
    #Saving config
    if [ saveconfig==true ]
    then
        echo "$token" > $XDG_CONFIG_HOME/tg-post/token.txt
        echo "$channel" > $XDG_CONFIG_HOME/tg-post/channel.txt
    fi
    
    if [ true ]
    then
        ftype=$(file -b --mime-type "${file}")
    
        case $ftype in
           image*)
           echo "Posting an image in ${channel}..."
           url='https://api.telegram.org/bot'$token'/sendPhoto'
           curl -s -o /dev/null "$url"'?chat_id='"$channel"'&caption='"$caption" --form 'photo=@'"$file"
           echo "Done!"
           ;;
           video*)
           echo "Posting a video in ${channel}..."
           url='https://api.telegram.org/bot'$token'/sendVideo'
           curl -s -o /dev/null "$url"'?chat_id='"$channel" --form 'video=@'"$file"
           echo "Done!"
           ;;
           audio*)
           echo "Posting an audio in ${channel}..."
           url='https://api.telegram.org/bot'$token'/sendAudio'
           curl -s -o /dev/null "$url"'?chat_id='"$channel" --form 'audio=@'"$file"
           echo "Done!"
           ;;
           *)
           echo "Posting a document in ${channel}..."
           url='https://api.telegram.org/bot'$token'/sendDocument'
           curl -s -o /dev/null "$url"'?chat_id='"$channel" --form 'document=@'"$file"
           echo "Done!"
           ;;
        esac
    else
        echo "Token or channel is invalid!"
    fi
fi
