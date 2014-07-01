echo "Process started at $(date +%m-%d-%Y-%T)"
'ec2-describe-snapshots' > ec2-snapshots
awk '{for(i=1;i<=NF;i++) if ($i=="SNAPSHOT") print $(i+1)}' ec2-snapshots > file
mv file ec2-snapshots
echo "WE HAVE A TOTAL OF"
wc -l ec2-snapshots
echo "AND"
'ec2-describe-volumes' > ec2-volumes
awk '{for(i=1;i<=NF;i++) if ($i=="VOLUME") print $(i+1)}' ec2-volumes > file
mv file ec2-volumes
echo "A TOTAL OF"
wc -l ec2-volumes

read -p "Do you want to start backup (y/n) " RU
        if [ "$RU" = "y" ];
                then echo "Starting Backup..."
                        cat ec2-volumes | while read line
                                do sudo ec2-create-snapshot $line
                                echo "Performing backup for $line";
                        done;
                echo "BACKUP IN PROGRESS AO $(date +%m-%d-%Y-%T). PLEASE CHECK AWS CONSOLE FOR STATUS"
                else echo "Exiting..."
        fi

read -p "Do you want to Delete old snapshots (y/n) " RU
        if [ "$RU" = "y" ];
                then echo "Deleting old backups..."
                        cat ec2-snapshots | while read line
                                do sudo ec2-delete-snapshot $line
                                echo "Deleting $line";
                        done;
                echo "DELETE IN PROGRESS. CHECK AWS CONSOLE FOR STATUS"
                else echo "Exiting..."
        fi

echo "Process completed at $(date +%m-%d-%Y-%T)"
