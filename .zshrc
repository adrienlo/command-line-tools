alias showHidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideHidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias zippy='zip -0 archive.zip -r . -x "*node_modules/*" "*.git/*" "*.DS_Store" "*.Thumbs.db"'

alias reload='. ~/.zshrc'

downloadFile() {
	filename=$(basename $1)

	curl -o ~/Desktop/$filename $1
}
