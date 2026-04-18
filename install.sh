#!/bin/bash -uo pipefail

# User welcome message
echo -e "\n####################################################################"
echo '# 👋 Installation of battopt for macOS 10.12 - 10.15'
echo -e "# Note: this script will ask for your password once or multiple times."
echo -e "####################################################################\n\n"

# Set environment variables
tempfolder=$HOME/.battopt-tmp
mkdir -p "$tempfolder"
function cleanup() { rm -rf "$tempfolder"; }
trap cleanup EXIT

# Ask for sudo once, in most systems this will cache the permissions for a bit
sudo echo "🔋 Starting battopt installation"
echo "[ 1 ] Superuser permissions acquired."

# Note: github names zips by <reponame>-<branchname>.replace( '/', '-' )
echo "[ 2 ] Downloading latest version of battopt"
curl -sSL -o "$tempfolder/battopt" "https://github.com/js4jiang5/BattOpt/releases/latest/download/battopt1012"
curl -sSL -o "$tempfolder/notification_permission.scpt" "https://github.com/js4jiang5/BattOpt/raw/refs/heads/main/assets/notification_permission.scpt"
sudo chmod -h 755 "$tempfolder/battopt"
sudo chmod -h 755 "$tempfolder/notification_permission.scpt"

echo "[ 3 ] Setup battopt"
sudo "$tempfolder/battopt" setup
eval $(/usr/libexec/path_helper -s) 

# Enable notification permission for Script Editor
echo "[ 4 ] Open Script Editor for notifications"
open -a "Script Editor" $tempfolder/notification_permission.scpt

empty="                                                                                  "
notice="Installation completed.

Script Editor is opened. Please manually click ▶️ in Script Editor for permission of notification,
then setup your MAC system settings as follows
1.	System Settings > Battery > Battery Health > click the ⓘ icon > toggle off \\\"Optimize Battery Charging\\\"
2.	System Settings > Notifications > enable \\\"Allow notifications when mirroring or sharing\\\"
3.	System Settings > Notifications > Applications > Script Editor > Choose \\\"Alerts\\\"
If Script Editor is missing in the Notifications list, please reboot your Mac and check again.
"
notice_tw="安裝完成.

工序指令編寫程序已打開, 請手動點擊工序指令編寫程序中的 ▶️  以允許通知.
接著請調整 MAC 系統設定如下
1.	系統設定 > 電池 > 電池健康度 > 點擊 ⓘ 圖標 > 關閉 \\\"最佳化電池充電\\\"
2.	系統設定 > 通知 > 開啟 \\\"在鏡像輸出或共享顯示器時允許通知\\\"
3.	系統設定 > 通知 > 應用程式通知 > 工序指令編寫程式 > 選擇 \\\"提示\\\"
如果通知中沒有工序指令編寫程式，請重啟你的 Mac 再確認一次.
"

notice_jp="インストールが完了しました。

スクリプトエディタが開きました。通知の許可を得るため、スクリプトエディタ内の ▶️ を手動でクリックしてください。
その後、Macのシステム設定を以下のように変更してください：

1. システム設定 > バッテリー > バッテリーの状態 > ⓘ アイコンをクリック > 「バッテリー充電の最適化」をオフにする
2. システム設定 > 通知 > 「画面のミラーリング中または共有中に通知を許可」をオンにする
3. システム設定 > 通知 > スクリプトエディタ > 「通知のスタイル」で「警告」を選択
通知リストにスクリプトエディタが表示されない場合は、Macを再起動して再度確認してください。
"

lang=$(defaults read -g AppleLocale | tr '[:upper:]' '[:lower:]');
if [[ $lang =~ "tw" ]]; then
	answer="$(osascript -e 'display dialog "'"$notice_tw"'" buttons {"'"$empty $empty"'", "完成"} default button 2 with icon note with title "battopt"' -e 'button returned of result')"
elif [[ $lang =~ "jp" ]]; then
	answer="$(osascript -e 'display dialog "'"$notice_jp"'" buttons {"'"$empty $empty"'", "完了"} default button 2 with icon note with title "battopt"' -e 'button returned of result')"
else
	answer="$(osascript -e 'display dialog "'"$notice"'" buttons {"'"$empty $empty"'", "Finish"} default button 2 with icon note with title "battopt"' -e 'button returned of result')"
fi
