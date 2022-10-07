run : script.sh
	./script.sh

scores : leaderboard.txt
	cat leaderboard.txt

reset-scores : leaderboard.txt
	truncate -s 27 leaderboard.txt

score-by : leaderboard.txt
	@echo "Veuillez saisir le nom du joueur :"; \
	read JOUEUR; \
	grep $$JOUEUR leaderboard.txt
