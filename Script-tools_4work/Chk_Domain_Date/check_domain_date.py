#!/usr/bin/python3

import whois

def get_domain_expiration_date(domain_name):
    domain_info = whois.whois(domain_name)
    expiration_date = domain_info.expiration_date
    return expiration_date

def read_domain_names_from_file(file_path):
    with open(file_path, 'r') as file:
        domain_names = file.readlines()
   
    domain_names = [domain.strip() for domain in domain_names]
    return domain_names

file_path = "domainlist"
domain_names = read_domain_names_from_file(file_path)

for domain_name in domain_names:
    expiration_date = get_domain_expiration_date(domain_name)
    
    if isinstance(expiration_date, list):
        expiration_date = expiration_date[0]

    if expiration_date:
        formatted_date = expiration_date.strftime("%Y/%m/%d")
        print(formatted_date, "  ", domain_name)
    else:
        print("無法獲取到期日期", "  ", domain_name)
