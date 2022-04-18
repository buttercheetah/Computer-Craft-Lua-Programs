#PLEASE NOTE!
#This is likely the worst possible implementation of flask, sqlite, and python you have ever seen.
#please do not use this as is. It has thousands of security issues and at would be extremely simple to inject data into the database if someone knew only the slightest bit of SQL.
from flask import Flask, request
import sqlite3
import random
people = sqlite3.connect('people.db')
print("Opened database successfully")
people.close()

app = Flask(__name__)
@app.route('/minecraft/api/hello/', methods=['GET', 'POST'])
def welcome():
	return "Hello World!"
@app.route('/minecraft/api/version/', methods=['GET'])
def getver():
	print("sending version")
	with open('version.txt') as f:
		return f.readline()
@app.route('/minecraft/api/setversion/', methods=['POST'])
def setver():
	with open('version.txt', 'w') as f:
		data = str(request.stream.read()).replace("b'", "").replace("'","")
		print(data)
		f.write(data)
	return 'True'
@app.route('/minecraft/api/anouncement/', methods=['GET'])
def anouncement():
	print("sending anouncement")
	with open('anouncement.txt') as f:
		return f.readline()
@app.route('/minecraft/api/setanouncement/', methods=['POST'])
def setanouncement():
	with open('anouncement.txt', 'w') as f:
		data = str(request.stream.read()).replace("b'", "").replace("'","")
		print(data)
		f.write(data)
	return 'True'
@app.route('/minecraft/api/echo/', methods=['POST'])
def echo():
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	print(data)
	return data
@app.route('/minecraft/api/advertisement/', methods=['GET'])
def advertisement():
	with open('advertisement.txt') as f:
		advertisements = f.readlines()
		print(len(advertisements))
	return str(advertisements[random.randrange(0,len(advertisements))]).replace("\n","")
@app.route('/minecraft/api/setadvertisement/', methods=['POST'])
def setadvertisement():
	with open('advertisement.txt', 'a') as f:
		data = str(request.stream.read()).replace("b'", "").replace("'","")
		f.write(str(data).replace("'", "") + "\n")
	return 'True'
@app.route('/minecraft/api/createuser/', methods=['POST'])
def createuser():
	people = sqlite3.connect('people.db')
	cursor = people.cursor()
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	try:
		cursor.execute("CREATE TABLE " + data + "(ITEM TEXT NOT NULL, PRICE INT NOT NULL)")
		print("Table created successfully")
		people.commit()
		people.close()
		return "True"
	except:
		print("Table already exists")
		people.close()
		return "False"
@app.route('/minecraft/api/getallusers/', methods=['GET'])
def returnallusers():
	people = sqlite3.connect('people.db')
	cursor = people.execute("SELECT name FROM sqlite_master WHERE type='table';")
	users = cursor.fetchall()
	people.close()
	return str(users)
@app.route('/minecraft/api/getalluserhistory/', methods=['POST'])
def getalluserhistory():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	print(data)
	try:
		cursor = people.execute("SELECT * FROM " + data + ";")
		total = cursor.fetchall()
		print(total)
		people.close()
		return "true"
	except:
		return 40400404
@app.route('/minecraft/api/applypurchase/', methods=['POST'])
def applypurchase():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	data = data.split("|")
	try:
		cursor = people.execute("INSERT INTO " + data[0] + " (ITEM, PRICE) VALUES ('" + data[1] + "', " + data[2] + ")")
		print("ran")
		cursor = people.commit()
		print("commited")
		cursor = people.close()
		return "True"
	except:
		people.close()
		return "False"
@app.route('/minecraft/api/getbal/', methods=['POST'])
def getbal():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	print(data)
	try:
		cursor = people.execute("SELECT sum(PRICE) FROM " + data + ";")
		total = str(cursor.fetchall()).replace("[(", "").replace(",", "").replace(")]", "")
		print(total)
		people.close()
		return total
	except:
		return 'False'
@app.route('/minecraft/api/login/', methods=['POST'])
def login():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	data = data.split("|")
	filed = str(str(data[0]) + ".txt")
	try:
		print("opening "+filed)
		with open(filed, 'r') as f:
			info = f.readline()
			print(info, data[1])
			if info == data[1]:
				return 'True'
			else:
				return 'False'
	except:
		return 'False'
@app.route('/minecraft/api/clogin/', methods=['POST'])
def clogin():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	data = data.split("|")
	playername = str(str(data[0]) + ".txt")
	oldpass = data[1]
	newpass = data[2]
	print(playername, oldpass, newpass)
	correct = False
	with open(playername, 'r') as f:
		info = f.readline()
		if info == oldpass:
			correct = True
		else:
			return 'False'
	if correct:
		with open(playername, 'w') as f:
			f.write(newpass)
			return 'True'
	else:
			return 'False'
@app.route('/minecraft/api/newuser/', methods=['POST'])
def newuser():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	f = open(data + ".txt", "x")
	with open(data + ".txt", 'a') as f:
		f.write("password")
	return 'True'
@app.route('/minecraft/api/getbalhistory/', methods=['POST'])
def getbalhistory():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b'", "").replace("'","")
	data = data.split("|")
	try:
		cursor = people.execute("SELECT * FROM " + data[0] + " ORDER BY rowid DESC LIMIT " + data[1] +";")
		total = str(cursor.fetchall()).replace("[(", "").replace("'", "").replace(")]", "").replace("(","").replace(",", "")
		print(total)
		people.close()
		return total
	except:
		return 'False'


@app.route('/minecraft/api/pc/gh/advertisement/', methods=['GET'])
def advertisement():
	with open('ghadvertisement.txt') as f:
		advertisements = f.readlines()
		print(len(advertisements))
	return str(advertisements[random.randrange(0,len(advertisements))]).replace("\n","")
@app.route('/minecraft/api/pc/gh/setadvertisement/', methods=['POST'])
def setadvertisement():
	with open('ghadvertisement.txt', 'a') as f:
		data = str(request.stream.read()).replace("b'", "").replace("'","")
		f.write(str(data).replace("'", "") + "\n")
	return 'True'


@app.route('/minecraft/api/pc/setversion/', methods=['POST'])
def setver():
	with open('pcversion.txt', 'w') as f:
		data = str(request.stream.read()).replace("b'", "").replace("'","")
		print(data)
		f.write(data)
	return 'True'
@app.route('/minecraft/api/pc/version/', methods=['GET'])
def getver():
	print("sending version")
	with open('pcversion.txt') as f:
		return f.readline()
if __name__ == '__main__':

	app.run(host='0.0.0.0', port=20)




def never():
	people = sqlite3.connect('people.db')
	data = str(request.stream.read()).replace("b", "").replace("'", "")
	data = str(data).split("|")
	people.execute("INSERT INTO people (NAME,BALANCE) VALUES ('" + str(data[0]) + "', " + str(data[1]) + ")")
	people.commit()
	people.close()
	return 'True'


	people = sqlite3.connect('people.db')
	cursor = people.execute("SELECT NAME from people")
	users = ""
	for row in cursor:
		users = users + " | " + str(row[0])
	people.close()
	return users