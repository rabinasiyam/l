#!/bin/bash

# Download and install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f

# Install Python and pip
sudo apt-get install -y python3
sudo apt-get install -y python3-pip

# Install required Python packages
pip3 install requests beautifulsoup4 selenium temp-mail

# Install ChromeDriver
sudo apt-get install -y chromium-chromedriver
export PATH=$PATH:/usr/lib/chromium-browser/

# Fetch a random fake name
fake_name=$(python3 - <<END
import requests
from bs4 import BeautifulSoup

def get_fake_name():
    url = "https://www.fakenamegenerator.com/"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    name_element = soup.find("div", class_="address")
    full_name = name_element.find("h3").text.strip().split()
    return ' '.join(full_name)

print(get_fake_name())
END
)

# Generate a temporary email address
temp_email=$(python3 - <<END
from tempmail import TempMail

tm = TempMail()
print(tm.get_email_address())
END
)

# Set up password
password="WickedPass123!"

# Navigate to Facebook's registration page
google-chrome "https://www.facebook.com/r.php" &

# Wait for Chrome to open
sleep 5

# Fill in the registration form with fake name, temporary email, and other details
python3 - <<END
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

driver = webdriver.Chrome()
driver.find_element_by_name("firstname").send_keys("$fake_name".split()[0])
driver.find_element_by_name("lastname").send_keys("$fake_name".split()[1])
driver.find_element_by_name("reg_email__").send_keys("$temp_email")
driver.find_element_by_name("reg_email_confirmation__").send_keys("$temp_email")
driver.find_element_by_name("reg_passwd__").send_keys("$password")
driver.find_element_by_name("websubmit").click()

# Wait for the verification process (you may need to adapt this based on Facebook's actual verification flow)
time.sleep(10)

# Kill the Chrome process
pkill chrome
END

# Witness the verified creation of your malevolent Facebook persona in the Chrome of the command line! 🌌💻
