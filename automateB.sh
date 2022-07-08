echo -e "${GREEN}Install 'virtualenv'${NC}"
pipx install virtualenv

echo -e "${GREEN}Install 'Node.js'${NC}"
curl -L https://bit.ly/n-install | bash -s -- -y lts

echo -e "${GREEN}Install 'pigpio'${NC}"
sudo apt-get install pigpio python3-pigpio

env="/home/${usr}/.venv/jupyter"
if [ ! -d "$env" ]; then
   echo -e "${GREEN}Create virtual environment for 'jupyter'${NC}"
   echo -e "    ${GREEN}at '$env'${NC}"
   virtualenv $env
else
   echo -e "${GREEN}'jupyter' virtual environment already exists${NC}"
fi

env="/home/${usr}/.venv/shades"
if [ ! -d "$env" ]; then
   echo -e "${GREEN}Create virtual environment for 'shades'${NC}"
   echo -e "    ${GREEN}at '$env'${NC}"
   virtualenv $env
else
   echo -e "${GREEN}'shades' virtual environment already exists${NC}"
fi