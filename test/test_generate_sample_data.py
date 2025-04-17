import os
import pytest
import csv
from scripts.generate_sample_data import generate_customer_csv

@pytest.fixture
def tmp_csv_file(tmp_path):
    return str(tmp_path / "test_customer_data.csv")


def test_generate_customer_csv_file(tmp_csv_file):
    generate_customer_csv(tmp_csv_file, record_count=10)
    assert os.path.isfile(tmp_csv_file)


def test_generate_customer_csv_creates_file(tmp_csv_file):
    generate_customer_csv(tmp_csv_file, record_count=10)
    assert os.path.exists(tmp_csv_file)

def test_generate_customer_csv_header(tmp_csv_file):
    generate_customer_csv(tmp_csv_file)

    with open(tmp_csv_file, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)

        assert header == ["customer_id","first_name","last_name","email","street",
                        "city","state","country"
                        ]

def test_generate_customer_csv_content(tmp_csv_file):
    record_count = 10
    generate_customer_csv(tmp_csv_file, record_count = record_count)

    with open(tmp_csv_file, 'r') as f:

        reader = csv.reader(f)
        next(reader)

        rows = list(reader)

        for row in rows:
            #test customer id

            assert 1 <= int(row[0]) <= record_count

def test_generate_customer_csv_different_sizes(tmp_csv_file):
    sizes = [0,1,10,100]

    for size in sizes: 
        generate_customer_csv(tmp_csv_file, record_count = size)

        with open(tmp_csv_file, 'r') as f:
            reader = csv.reader(f)
            next(reader)
            rows = list(reader)
            assert len(rows) == size

def test_generate_customer_csv_invalid_input(tmp_csv_file):
    with pytest.raises(ValueError):
        generate_customer_csv(tmp_csv_file, record_count = -1)

        


