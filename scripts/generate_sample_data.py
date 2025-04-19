from faker import Faker
import csv
import random
import os
from decimal import Decimal
from datetime import datetime, timedelta

fake = Faker()
#current_time = datetime.now().strftime("%Y%m%d%H%M%S")

def generate_customer_csv(filename, record_count = 10000):
        
        if record_count < 0:
             raise ValueError("Number of records must be positive")
        
        os.makedirs(os.path.dirname(filename), exist_ok = True)

        try:
            with open(filename, 'w', newline='') as csvfile:
                fieldnames = ["timestamp", "customer_id","first_name","last_name","email","street",
                        "city","state"
                        ]
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

                writer.writeheader()
                for i in range(record_count):
                #print(i)
                    writer.writerow(
                        {
                            "timestamp": (datetime.now() - timedelta(days=random.randint(0,365))).isoformat(),
                            "customer_id": fake.random_int(min=1, max=record_count),
                            'first_name': fake.first_name(),
                            'last_name': fake.last_name(),
                            'email': fake.email(),
                            'street': fake.street_address(),
                            'city': fake.city(),
                            'state': fake.state(),
                        }
                    )
        except (IOError, OSError) as e:
             raise Exception(f"Failed to generate customer csv file {e}")



if __name__ == '__main__':
    generate_customer_csv("data/customer_data.csv")