sudo yum install -y mysql-community-devel --nogpgcheck
sudo yum install -y munge munge-libs munge-devel

# Create SLURM user and group
sudo groupadd -r slurm
sudo useradd -r -g slurm -d /var/lib/slurm -s /sbin/nologin -c "SLURM workload manager" slurm

mkdir /opt/slurm-al2023
cd /opt/slurm-al2023
wget "https://github.com/jigar-panchal/basesolve-public-assets/blob/main/slurm-al23/slurm-23.11.6-1.amzn2023.x86_64.rpm"
wget "https://github.com/jigar-panchal/basesolve-public-assets/blob/main/slurm-al23/slurm-slurmd-23.11.6-1.amzn2023.x86_64.rpm"
wget "https://github.com/jigar-panchal/basesolve-public-assets/blob/main/slurm-al23/slurm-slurmdbd-23.11.6-1.amzn2023.x86_64.rpm"
wget "https://github.com/jigar-panchal/basesolve-public-assets/blob/main/slurm-al23/slurm-slurmctld-23.11.6-1.amzn2023.x86_64.rpm"
wget "https://raw.githubusercontent.com/jigar-panchal/basesolve-public-assets/main/slurm-al23/slurm.conf"
wget "https://raw.githubusercontent.com/jigar-panchal/basesolve-public-assets/main/slurm-al23/slurmdbd.conf"
wget "https://raw.githubusercontent.com/jigar-panchal/basesolve-public-assets/main/slurm-al23/slurmctld.service"
wget "https://raw.githubusercontent.com/jigar-panchal/basesolve-public-assets/main/slurm-al23/slurmd.service"
wget "https://raw.githubusercontent.com/jigar-panchal/basesolve-public-assets/main/slurm-al23/slurmdbd.service"
sudo yum localinstall ./slurm-23.11.6-1.amzn2023.x86_64.rpm ./slurm-slurmd-23.11.6-1.amzn2023.x86_64.rpm ./slurm-slurmctld-23.11.6-1.amzn2023.x86_64.rpm

# Create necessary directories
sudo mkdir /etc/slurm/
sudo mkdir -p /var/spool/slurmd
sudo chown slurm:slurm /var/spool/slurmd
sudo mkdir -p /var/spool/slurmctld
sudo chown slurm:slurm /var/spool/slurmctld
sudo mkdir /var/log/slurm
sudo chown slurm:slurm /var/log/slurm


# Generate MUNGE key
#sudo /usr/sbin/create-munge-key
sudo mungekey --create
sudo chown -R munge:munge /etc/munge
sudo chmod 0700 /etc/munge
sudo systemctl enable munge
sudo systemctl start munge

# Copy Service & conf file
sudo cp slurmdbd.service slurmd.service slurmctld.service /etc/systemd/system/
sudo cp slurm.conf slurmdbd.conf /etc/slurm/

# Enable and start SLURM services
sudo systemctl daemon-reload
sudo systemctl enable slurmctld
# sudo systemctl start slurmctld
sudo systemctl enable slurmd
# sudo systemctl start slurmd
sudo systemctl enable slurmdbd
# sudo systemctl start slurmdbd
