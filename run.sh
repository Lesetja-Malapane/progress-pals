#bin/bash

echo "\nRunning Flutter clean and pub get\n"
flutter clean
flutter pub get

echo "\n"

PS3='Please enter your choice: '
options=("1 -> debug" "2 -> profile" "3 -> release" "4 -> show commands" "5 -> quit")
select opt in "${options[@]}"
do
    case $opt in
        "1 -> debug")
            echo "\n--------Running in debug mode--------\n"
            flutter run --debug
            ;;
        "2 -> profile")
            echo "\n--------Running in profile mode--------\n"
            flutter run --profile
            ;;
        "3 -> release")
            echo "\n--------Running in release mode--------\n"
            flutter run --release
            ;;
        "4 -> show commands")
            echo "\n--------List Of Commands--------\n"
            echo "1 -> debug \n2 -> profile \n3 -> release \n4 -> print commands \n5 -> quit\n"
            ;;
        "5 -> quit")
            echo "\n--------Quitting Run Script--------\n"
            break
            ;;
        *) echo "invalid option $REPLY choose between (1-5)";;
    esac
done