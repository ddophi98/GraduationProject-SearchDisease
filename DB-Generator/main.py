import csv
import sqlite3


con = sqlite3.connect('disease.db')
cur = con.cursor()

cur.execute('drop table if exists disease;')
cur.execute('drop table if exists department;')
cur.execute('create table disease(id integer primary key autoincrement, name text, definition text, '
            'cause text, symptom text, diagnosis text, cure text);')
cur.execute('create table department(id integer primary key autoincrement, disease_id integer, name text);')

with open("disease_data.csv", "r", encoding='utf-8-sig') as file:
    reader = csv.DictReader(file)
    for row in reader:
        cur.execute("select exists(select 1 from disease where name = ?);", (row['name'],))
        exist = True if (cur.fetchone()[0] == 1) else False
        # cur.execute("insert into disease(name, definition, cause, symptom, diagnosis, cure) "
        #             "select ?, ?, ?, ?, ?, ? where not exists(select * from disease where name = ?);"
        #             , (row['name'], row['definition'], row['cause'], row['symptom'], row['diagnosis'], row['cure'], row['name']))
        if not exist:
            cur.execute('insert into disease(name, definition, cause, symptom, diagnosis, cure) values(?, ?, ?, ? ,?, ?);'
                        , (row['name'], row['definition'], row['cause'], row['symptom'], row['diagnosis'], row['cure']))
            disease_id = cur.lastrowid

            departments = filter(lambda x: x != '', row['medical_department'].replace('"', "").split(", "))
            for department in departments:
                cur.execute('insert into department(disease_id, name) values(?, ?)', (disease_id, department))
con.commit()

cur.execute('drop table if exists symptom')
# cur.execute('create table symptom(id integer primary key autoincrement, date timestamp default current_timestamp, content text);')
con.commit()