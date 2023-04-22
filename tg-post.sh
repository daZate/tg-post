if [[ "$1" == "" ]]
then
   echo "Usage: tg-post (file_name) [@channel_name]"
else
    token=`cat token.txt`
    file=`echo $1`
    channel=$([ "$2" == "" ] && cat "channel.txt" || echo "$2")
    ftype=`file -b --mime-type ${file}`
    
    case $ftype in
       image*) 
       echo "Posting an image in ${channel}..."
       url='https://api.telegram.org/bot'$token'/sendPhoto'
       curl -s -o /dev/null $url'?chat_id='$channel --form 'photo=@'$file
       echo "Done!"
       ;;
       video*) 
       echo "Posting a video in ${channel}..."
       url='https://api.telegram.org/bot'$token'/sendVideo'
       curl -s -o /dev/null $url'?chat_id='$channel --form 'video=@'$file
       echo "Done!"
       ;;
       audio*)
       echo "Posting an audio in ${channel}..."
       url='https://api.telegram.org/bot'$token'/sendAudio'
       curl -s -o /dev/null $url'?chat_id='$channel --form 'audio=@'$file
       echo "Done!"
       ;;
       *) 
       echo "Posting a document in ${channel}..."
       url='https://api.telegram.org/bot'$token'/sendDocument'
       curl -s -o /dev/null $url'?chat_id='$channel --form 'document=@'$file
       echo "Done!"
       ;;
    esac
fi
