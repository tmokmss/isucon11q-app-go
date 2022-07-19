db:
	@sudo systemctl restart mysql.service

nginx:
	@sudo systemctl restart nginx.service

app:
	@sudo systemctl restart isucondition.go.service

systemctl-list:
	systemctl list-unit-files --type=service

alp:
	sudo cat /var/log/nginx/access.log | alp ltsv -m '/api/condition/.*','/isu/.*/condition','/isu/.*/graph','/api/isu/.*/icon','/api/isu/.*','/isu/.*','/assets/.*'

ptq:
	sudo pt-query-digest --limit 10 /var/log/mysql/mariadb-slow.log

reset-log:
	sudo rm /var/log/mysql/mariadb-slow.log
	sudo rm /var/log/nginx/access.log
	make db
	make nginx
