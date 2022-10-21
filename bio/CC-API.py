#PLEASE NOTE!
#This is likely the worst possible implementation of flask, sqlite, and python you have ever seen.
#please do not use this as is. It has thousands of security issues and at would be extremely simple to inject data into the database if someone knew only the slightest bit of SQL.
from flask import Flask, request
import sqlite3
import random
import mariadb
import time
from datetime import date

app = Flask(__name__)

def checkcred(user,password):
	cur.execute("select Username,Password from MC_User where Username='"+user+"' and Password='"+password+"';")
	rows = cur.fetchall()
	if not rows:
		return False
	else:
		return True

def returnpretty(l):
	result = ""
	#for itemnum in range(len(l)):
	#	if itemnum == 0:
	#		result += str(l[itemnum])
	#	else:
	#		spacing = 5
	#		spacing = spacing - len(str(l[itemnum-1]))
	#		result += str(str(" " * spacing) + str(l[itemnum]))
	#	if itemnum == len(l)-1:
	#		pass
	#	else:
	#		result += "|"
	#return result
	for itemnum in range(len(l)):
		spacing = 6
		spacing = spacing - len(str(l[itemnum]))
		result += str(str(l[itemnum]) + str(" " * spacing))
		if itemnum == len(l)-1:
			pass
		else:
			result += "|"
	return result

def getign(user,password):
	cur.execute("select MCUser from MC_User where Username='"+user+"' and Password='"+password+"';")
	rows = cur.fetchall()
	if not rows:
		return False
	else:
		if type(rows[0]) == tuple:
			return rows[0][0]
		else:
			return rows[0]

def checkifstoreexists(name):
	cur.execute("select Store_Name from MC_Store_list where Store_Name='"+name+"';")
	rows = cur.fetchall()
	if not rows:
		return False
	else:
		return True

def getuserbalance(ign):
	cur.execute("select sum(Ammount) from MC_User_Bank where User='"+ign+"';")
	rows = cur.fetchall()
	if type(rows[0]) == tuple:
		return rows[0][0]
	else:
		return rows[0]

def getstoreid(name):
	cur.execute("select ID from MC_Store_list where Store_Name='"+name+"';")
	rows = cur.fetchall()
	if type(rows[0]) == tuple:
		return rows[0][0]
	else:
		return rows[0]

def returnuserign(ign):
	cur.execute("select MCUser from MC_User where MCUser='"+ign+"';")
	rows = cur.fetchall()
	if not rows:
		return False
	else:
		if type(rows[0]) == tuple:
			return rows[0][0]
		else:
			return rows[0]
@app.route('/minecraft/api/hello/', methods=['GET', 'POST'])
def welcome():
	return "Hello World!"
@app.route('/echo', methods=['POST'])
def echo():
	data = request.stream.read()
	data = data.decode("utf-8")
	print(data)
	return data
@app.route('/minecraft/api/createaccount', methods=['POST'])
def createaccount():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data=data.split("|")
		cur.execute("select MCUser from MC_User where MCUser='"+str(data[0])+"';")
		rows = cur.fetchall()
		print(rows,data)
		if rows:
			return "Account already exists"
		else:
			cur.execute("INSERT INTO MC_User (Account_Created,MCUser,Username,Password) VALUES (?, ?, ?, ?);", (timee, data[0], data[1], data[2]))
			conn.commit()
			cur.execute("INSERT INTO MC_User_Bank (DateTime,User,Ammount,Description) VALUES (?, ?, ?, ?);", (timee, data[0], 0, "Account Opened"))
			conn.commit()
			return "Account Created"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/login', methods=['POST'])
def login():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]) == True:
			print(getign(data[0], data[1],),"logged in")
			return "True"
		else:
			print("wrong creds")
			return "False"
	except Exception as e:
		print(e)
		return "False"
@app.route('/minecraft/api/getbal', methods=['POST'])
def getbal():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			return str(getuserbalance(ign))
		else:
			return "Unkown error occured"
	except:
		return "Unkown error occured"
@app.route('/minecraft/api/inputtransaction', methods=['POST'])
def inputtransaction():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("INSERT INTO MC_User_Bank (DateTime,User,Ammount,Description) VALUES (?, ?, ?, ?);", (timee, ign, data[2], data[3]))
			conn.commit()
			return "True"
		else:
			return "False"
	except:
		return "False"
@app.route('/minecraft/api/createstore', methods=['POST'])
def createstore():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		print(data)
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			print(ign)
			if not checkifstoreexists(data[2]):
				cur.execute("INSERT INTO MC_Store_list (Creation_Time,User,Store_Name,Store_Description,Open) VALUES (?, ?, ?, ?, ?);", (timee, ign, data[2], data[3], 1))
				conn.commit()
				return "Store Created"
			else:
				return "Store name already in use"
		else:
			return "Login incorrect"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/getownedshoplist', methods=['POST'])
def getownedshoplist():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		ign = getign(data[0],data[1])
		cur.execute("select Store_Name from MC_Store_list where User='"+str(ign)+"';")
		rows = cur.fetchall()
		result = ""
		for i in range(len(rows)):
			result = result + rows[i][0]
			if i != len(rows) -1:
				print("e")
				result = result + "|"
		return result
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/getshoplist', methods=['POST'])
def getshoplist():
	recon()
	try:
		cur.execute("select Store_Name from MC_Store_list where MC_Store_list.Open=1;")
		rows = cur.fetchall()
		result = ""
		for i in range(len(rows)):
			result = result + rows[i][0]
			if i != len(rows) -1:
				print("e")
				result = result + "|"
		return result
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/placeorderatstore', methods=['POST'])
def placeorderatstore():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		print(data)
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			print(ign)
			storeID = getstoreid(data[2])
			cur.execute("INSERT INTO MC_Store_orders (Order_Time,User,Store_ID,Order_Description,Done) VALUES (?, ?, ?, ?, ?);", (timee, ign, storeID, data[3],False))
			conn.commit()
			return "Order Placed"
		else:
			return "wrong credentials"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/getshopdetails', methods=['POST'])
def getshopdetails():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		cur.execute("select User,Store_Name,Store_Description from MC_Store_list where Store_Name='"+str(data)+"';")
		rows = cur.fetchall()
		result = rows[0][0] + "|" + rows[0][1] + "|" + rows[0][2]
		return result
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/getshopdetailsadvanced', methods=['POST'])
def getshopdetailsadvanced():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		cur.execute("select Open,Store_Name,Store_Description from MC_Store_list where Store_Name='"+str(data)+"';")
		rows = cur.fetchall()
		result = str(rows[0][0]) + "|" + rows[0][1] + "|" + rows[0][2]
		return result
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/checkandcorrectuser', methods=['POST'])
def checkandcorrectuser():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		return str(returnuserign(data))
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/transferfunds', methods=['POST'])
def transferfunds():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("INSERT INTO MC_User_Bank (DateTime,User,Ammount,Description) VALUES (?, ?, ?, ?);", (timee, ign, int(int(data[3])*(-1)),str("Transfer to " + str(data[2]) + " : " + str(data[4]))))
			cur.execute("INSERT INTO MC_User_Bank (DateTime,User,Ammount,Description) VALUES (?, ?, ?, ?);", (timee, data[2], int(data[3]),str("Transfer to " + str(ign) + " : " + str(data[4]))))
			conn.commit()
			return "Transaction Successfull"
		else:
			return "Inccorect Credentials"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/gettransactions', methods=['POST'])
def gettransactions():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("select Transaction_ID,ammount,Description from MC_User_Bank where User='"+ign+"' order by Transaction_ID DESC limit "+data[2]+";")
			rows = cur.fetchall()
			result = ""
			for i in rows:
				result += "ID: " + str(i[0]) + "\nAmount: " + str(i[1]) + "\nDescription:\n" + str(i[2])
				result += "\n\n"
			return str(result)
		else:
			return "Unkown error occured"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/toggleopen', methods=['POST'])
def toggleopen():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		print(data)
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("UPDATE MC_Store_list set MC_Store_list.Open="+data[3]+" where Store_Name='"+str(data[2])+"';")
			#rows = cur.fetchall()
			#print(rows)
			conn.commit()
			return "True"
		else:
			return "Incorrect Credentials"
	except Exception as e:
		print(e)
		return str(e)
@app.route('/minecraft/api/changeshopdesc', methods=['POST'])
def changeshopdesc():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		print(data)
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("UPDATE MC_Store_list set MC_Store_list.Store_Description='"+data[3]+"' where Store_Name='"+str(data[2])+"';")
			#rows = cur.fetchall()
			#print(rows)
			conn.commit()
			return "True"
		else:
			return "Incorrect Credentials"
	except Exception as e:
		print(e)
		return str(e)
@app.route('/minecraft/api/banktransaction', methods=['POST'])
def banktransaction():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		ign = returnuserign(data[0])
		if ign == False:
			return "Incorrect ign"
		cur.execute("INSERT INTO MC_User_Bank (DateTime,User,Ammount,Description) VALUES (?, ?, ?, ?);", (timee, ign, int(data[2]),str("Bank " + data[1])))		
		conn.commit()
		return "Transaction Successfull"
	except Exception as e:
		return str(e)

@app.route('/minecraft/api/getordersfromownedstore', methods=['POST'])
def getordersfromownedstore():
	recon()
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("select MC.MC_Store_orders.Order_ID, MC.MC_Store_orders.`User`, MC.MC_Store_orders.Order_Description, MC.MC_Store_list.Store_Name from MC.MC_Store_orders Join MC.MC_Store_list on (MC.MC_Store_list.ID=MC.MC_Store_orders.Store_ID) where MC.MC_Store_list.`User`='"+str(ign)+"' and MC.MC_Store_orders.Done=0 order by MC.MC_Store_orders.Order_ID desc limit 1;")
			rows = cur.fetchall()
			print(rows)
			print(len(rows))
			if len(rows) == 0:
				return "No Orders"
			for i in rows:
				result = str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + "|" + str(i[3])
			return str(result)
		else:
			return "Unkown error occured"
	except Exception as e:
		return str(e)
@app.route('/minecraft/api/changeorderstatus', methods=['POST'])
def changeorderstatus():
	recon()
	timee = time.strftime('%Y-%m-%d %H:%M:%S')
	try:
		data = request.stream.read()
		data = data.decode("utf-8")
		data = data.split("|")
		print(data)
		if checkcred(data[0], data[1]):
			ign = getign(data[0],data[1])
			cur.execute("UPDATE MC_Store_orders set MC_Store_orders.Done="+data[3]+" where MC_Store_orders.Order_ID='"+str(data[2])+"';")
			conn.commit()
			return "True"
		else:
			return "Incorrect Credentials"
	except Exception as e:
		print(e)
		return str(e)
def recon():
	global conn,cur
	user = "User"
	password = "Pass"
	host = "192.168.0.213"
	port = 3866
	database = "MC"
	try:
		conn = mariadb.connect(
			user=str(user),
			password=str(password),
			host=str(host),
			port=int(port),
			database=str(database)
		)
	except mariadb.Error as e:
		sys.exit(1)
	cur = conn.cursor()
if __name__ == '__main__':
	global user, password, host, port, database,cur, conn
	user = "User"
	password = "Pass"
	host = "192.168.0.213"
	port = 3866
	database = "MC"

	try:
		conn = mariadb.connect(
			user=str(user),
			password=str(password),
			host=str(host),
			port=int(port),
			database=str(database)
		)
	except mariadb.Error as e:
		sys.exit(1)
	cur = conn.cursor()
	# Create Users Table
	try:
		cur.execute("Create table MC_User (UID int unsigned auto_increment, Account_Created DateTime, MCUser varchar(255) unique, Username varchar(255), Password varchar(255), PRIMARY KEY (UID))")
		conn.commit()
	except Exception as e:
		print(e)
	# Create Bank Table
	try:
		cur.execute("Create table MC_User_Bank (Transaction_ID int unsigned auto_increment, DateTime DateTime, User varchar(255), Ammount int, Description LONGTEXT, PRIMARY KEY (Transaction_ID));")
		conn.commit()
	except Exception as e:
		print(e)
	# Create store table
	try:
		cur.execute("Create table MC_Store_list (ID int unsigned auto_increment, Creation_Time DateTime, User varchar(255), Store_Name varchar(255), Store_Description LONGTEXT, Open bool, PRIMARY KEY (ID));")
		conn.commit()
	except Exception as e:
		print(e)
	try:
		cur.execute("Create table MC_Store_orders (Order_ID int unsigned auto_increment, Order_Time DateTime, User varchar(255), Store_ID int unsigned, Order_Description LONGTEXT, Done bool, PRIMARY KEY (Order_ID), FOREIGN KEY (Store_ID) REFERENCES MC_Store_list (ID));")
		conn.commit()
	except Exception as e:
		print(e)
	app.run(host='0.0.0.0', port=8000)

