all:
make db-backup
make ruby
make db
make reset-log

init:
sudo systemctl disable --now isucondition.go.service
sudo systemctl enable --now isucondition.ruby.service
make ruby

ruby:
sudo systemctl restart --now isucondition.ruby.service

db:
@sudo systemctl restart mysql.service

db-backup:
@sudo mysqldump isucondition > /var/log/mysql/backup-`date +%m%d-%H%M%S`

nginx:
@sudo systemctl restart nginx.service

systemctl-list:
systemctl list-unit-files --type=service
alp:
sudo cat /var/log/nginx/access.log | alp ltsv -m '/api/isu/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/graph','/api/isu/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/icon','/api/isu/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/','/api/condition/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}','/isu/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
pt-query-digest:
pt-query-digest --limit 10 /var/log/mysql/mariadb-slow.log
# pt-query-digest --limit 10 /var/log/mysql/mysql-slow.log

dump-log:
mkdir -p /var/log/mysql/backup/
mkdir -p /var/log/nginx/backup/
-cp /var/log/mysql/access.log /var/log/mysql/backup/access-`date +%m%d-%H%M%S`.log
-cp /var/log/mysql/mariadb-slow.log /var/log/mysql/backup/mariadb-slow-`date +%m%d-%H%M%S`.log
-cp /var/log/nginx/access.log /var/log/nginx/backup/-`date +%m%d-%H%M%S`.log

reset-log:
make dump-log
-sudo rm /var/log/mysql/mysql-slow.log
-sudo rm /var/log/nginx/access.log
make db
make nginx
