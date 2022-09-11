#coding=UTF-8
#This Python file uses the following encoding:utf-8
import pymysql
from flask import Flask, request,send_file
import json
import datetime
import time
import random
import os
import subprocess
import cv2
import yolov4Prediction
import numpy as np
import argparse
import time
import cv2
import os
from flask import Flask, request, Response, jsonify
import jsonpickle
#import binascii
import io as StringIO
import base64
from io import BytesIO
import io
import json
from PIL import Image
# 打开数据库连接

#使用 cursor() 方法创建一个游标对象 cursor
#db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
#cursor = db.cursor()


breakfast = time.strptime("12 0 0","%H %M %S")
lunch = time.strptime("16 0 0","%H %M %S")
app = Flask(__name__)
app.config["DEBUG"] = True
#the file save all upload files
app.config['UPLOAD_FOLDER'] = "./uploadFile"
app.config['YOLOV4']='./darknet'

@app.route('/home', methods=['GET'])
def home():
    print("1123")
    return "<h1>Hello Flask!</h1>"

@app.route('/login',methods = ['POST'])#登入
def login():
    data = request.get_data()
    #print(data)
    try:
        jsondata = json.loads(data)
        if(type(jsondata) == int):
            print("Cannot post only int")
            return 'Cannot post only int'
    except ValueError:
        print("Error type")
        return "Error type"
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    
    cursor.execute("select * from USER where account = %s&&password = %s",(jsondata['account'],jsondata['password']))
    data = cursor.fetchone()
    cursor.close()
    x = {
        "LoginIsSuccess" : True
    }
    if(data == None) :
        x['LoginIsSuccess'] = False
        print("Login fail")
        db.close()
        return json.dumps(x)
    print("Login Success")
    db.close()
    return json.dumps(x)

@app.route('/foodInput/<account>',methods = ['POST'])#
def foodInput(account):
    data = request.get_data()
    try:
        jsondata = json.loads(data)
        if(type(jsondata) == int):
            return 'Cannot post only int'
    except ValueError:
        return "Error type"
    
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute("select account from USER where account = %s",account)
    datatmp = cursor.fetchone()
    if datatmp == None : 
        db.close()
        return "fail to get ID from account : %s"%account
    userID = datatmp[0]
    foodList = jsondata["foodName"]
    foodPortionList = jsondata['foodPortion']
    timeTmp = time.strptime(jsondata["time"].replace(":"," "),"%H %M")
    if timeTmp < breakfast:
        mealTime = 1
    elif timeTmp < lunch:
        mealTime = 2
    else:
        mealTime = 3
    date = datetime.datetime.now()
    dateString = date.strftime("%Y-%m-%d")
    db_commit = 'insert into Meal value(null,%s,%s,%s,%s,%s,%s,%s,%s,%s)'
    # print(foodList)
    for i in range(len(foodList)):
        print("select * from FOOD where name = %s",foodList[i])
        cursor.execute("select * from FOOD where name = %s",foodList[i])
        foodData = cursor.fetchone()
        foodPortion = []
        print(foodData)
        for j in range(1,len(foodData)):
            foodPortion.append(float(foodData[j]) * float(foodPortionList[i]))

        cursor.execute(db_commit,(userID,dateString,foodList[i],foodPortion[0],foodPortion[1],foodPortion[2],foodPortion[3],foodPortion[4],mealTime))
        #userID / date / foodName / foodType / mealtime
    cursor.close()
    db.commit()
    db.close()
    return "insert success"

@app.route("/foodList" ,methods = ["POST"])#改post
def mealOutput():
    data = request.get_data()
    try:
        jsondata = json.loads(data)
        if(type(jsondata) == int):
            return 'Cannot post only int'
    except ValueError:
        return "Error type"
    account = jsondata["account"]
    date = jsondata["date"]
    breakfastList = []
    lunchList = []
    dinnerList = []
    
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute("select account from USER where account = %s",account)
    data = cursor.fetchone()
    
    if data == None:
        db.close()
        return "fail to get userID from account : %s"%account
    userID = data[0]
    cursor.execute("select * from Meal where userID = %s and date = %s",(userID,date))
    data = cursor.fetchall()
    print(len(data))
    if data != None:
        foodTypeLowLimit = [2,3,3,1,1,2]#定死，五大類食物每日建議攝取量
        foodTypeHighLimit = [4,8,5,2,2,4]
        foodType = ['grains','meat','vegetable','milk','fish','egg']
        foodTypeChinese = ['穀物類','蛋豆魚肉類','蔬菜類','乳品類','堅果類','水果類']
        userFoodTypeSum = [0] * 6
        output = []
        for i in data:
            x = {
                "Date" : i[2],
                "foodName" : i[3],
                "rice" : float(i[4]),
                "meat" : float(i[5]),
                "vegetable" : float(i[6]),
                "milk" : float(i[7]),
                "nut" : float(i[8]),
                "fruit" : 0.5 #先放假資料
            }
            if i[9] == 1:
                breakfastList.append(x)
            elif i[9] == 2:
                lunchList.append(x)
            else:
                dinnerList.append(x)
            for j in range(6):#6大類
                userFoodTypeSum[j] = userFoodTypeSum[j] + int(i[j+4])
        print(userFoodTypeSum)
        color = []
        progressView = []
        for i in range(len(userFoodTypeSum)):
            if userFoodTypeSum[i] > foodTypeLowLimit[i]*2 :#如果大於建議攝取量的2倍
                color.append('red')
            elif userFoodTypeSum[i] > foodTypeLowLimit[i] :
                color.append('green')
            else:
                color.append('orange')
            progressView.append(float(userFoodTypeSum[i])/foodTypeHighLimit[i])
        print("=======================================")
        x = {
            "progressView" : progressView,
            "color" : color,
            'image' : foodType,
            'foodType' : foodTypeChinese,
            "breakfast" : breakfastList,
            "lunch" : lunchList,
            "dinner" : dinnerList
        }
    else:
        x = {
            "progressView": [0]*6,
            "color": ['orange']*6,
            'image' : foodType,
            'foodType' : foodTypeChinese,
            "breakfast" : breakfastList,
            "lunch" : lunchList,
            "dinner" : dinnerList
        }
    cursor.close()
    db.close()
    return json.dumps(x,indent = 2,ensure_ascii=False).encode('utf-8').decode('utf8')
    # read this issue https://stackoverflow.com/questions/10406135/unicodedecodeerror-ascii-codec-cant-decode-byte-0xd1-in-position-2-ordinal

@app.route('/announcement')#for 公告
def announcement() :
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute("select * from Notification_MESSAGE;")
    data = cursor.fetchall()
    dataList = list()
    for i in data :
        x = {
            "title" : i[0],
            "document" : i[2],
            "date" : i[1]
        }
        dataList.append(x)
    db.close()
    return json.dumps(dataList,indent = 2,  ensure_ascii=False).encode('utf8').decode('utf8')

@app.route('/a_week_data',methods = ['POST'])
def forweek() :
    data = request.get_data()
    try:
        jsondata = json.loads(data)
        if(type(jsondata) == int):
            return 'Cannot post only int'
    except ValueError:
        return "Error type"
    account = jsondata['account']
    
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute('select account from USER where account = %s',account)
    data = cursor.fetchone()
    
    if data == None :
        print("fail to get ID from account : %s",account)
        db.close()
        return "fail to get userID"
    userID = data[0]
    date = datetime.datetime.now()
    delay = datetime.timedelta(days = 1)
    weekdata = list()
    for i in range(7) :
        date = date - delay
        cursor.execute('select * from Info where userID = %s && date = %s',(userID,date.strftime('%Y-%m-%d')))
        data = cursor.fetchone()
        if data == None :
            x = {
                'date' : date.strftime("%m-%d"),
                'step' : -1,
                'sleep' : -1,
                'calories' : -1
            }
        else : 
            datafordate = str(data[2])
            datafordate = datafordate.replace("-","/")
            datasplit = datafordate.split("/")
            MonAndDay = str(int(datasplit[1])) + '/' + str(int(datasplit[2]))#去掉前面的零+排版
            x = {
                'date' : MonAndDay,#只要月份日期
                'calories' : data[3],
                'step' : data[4],
                'sleep' : data[5]
            }

        weekdata.append(x)
    print('得到每週資料')
    cursor.close()
    db.close()
    return json.dumps(weekdata,indent =2)

@app.route('/fakedata/<account>/<date>')
def makefakedata(account,date) : 
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute("select account from USER where account = %s",account)
    
    data = cursor.fetchone()
    if data == None : 
        db.close()
        return "fail to get ID from account : %s"%account
    userID = 'sora'
    calories = random.randint(1500,3500)
    step = random.randint(3000,15000)
    sleep = random.randint(3,12)
    db.commit()
    cursor.execute('insert into Info (userID,date,calories,step,sleep) Values (%s,%s,%s,%s,%s)',(userID,date,calories,step,sleep))
    cursor.close()
    db.commit()
    db.close()
    return "insert success"

@app.route('/sendImage/<imageName>')
def sendImage(imageName):
    fileName = "image/" + imageName
    try :
        filePath = fileName + ".jpg"
        return send_file(filePath,mimetype = "image/jpeg")
    except :
        filePath = fileName + ".png"
        return send_file(filePath,mimetype = "image/png")


@app.route('/foodRecommend',methods = ['Post'])
def foodRecommend():
    data = request.get_data()
    try:
        jsondata = json.loads(data)
        if(type(jsondata) == int):
            return 'Cannot post only int'
    except ValueError:
        return "Error type"
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    
    cursor.execute("select account from USER where account = %s",jsondata['account'])
    data = cursor.fetchone()
    if data == None:
        print("fail to get userID from account = %s",account)
        db.close()
        return "fail to get userID from account = %s"%account
    userID = data[0]
    date = datetime.datetime.now().strftime('%Y-%m-%d')
    tempstr = 'select sum(meat),sum(vegetables),sum(fish),sum(egg),sum(grains) from Meal where userID = %s and date = %s'
    cursor.execute(tempstr,(userID,date))
    userFoodTypeSum = cursor.fetchall()
    foodTypeLowLimit = [2,3,3,1,1,2]#定死，五大類食物每日建議攝取量
    foodType = ['grains','meat','fish','egg','vegetables']
    recommendList = []
    print(userFoodTypeSum)
    print(userFoodTypeSum[0][0])
    for i in range(5):#5大類
        if userFoodTypeSum[0][i] < foodTypeLowLimit[i]:
            cursor.execute("select name from FOOD where %s < %s",(foodType[i],foodTypeLowLimit[i]-userFoodTypeSum[0][i]))
            data = cursor.fetchall()
            for j in data:
                if j[0] not in recommendList:
                    recommendList.append(j[0])
    output = []
    for i in range(3):
        if len(recommendList) == 0:
            break
        else:
            ranInt = random.randint(0,len(recommendList)-1)
            output.append(recommendList[ranInt])
    print(output)
    x = {
        'recommend' : output
    }
    cursor.close()
    db.close()
    return json.dumps(x,indent = 1,ensure_ascii=False).encode('utf8')




@app.route('/uploadEulrAngleDistance', methods = ['Post'])
def uploadEulrAngleDistance():
    #print("upload")
    data = request.get_data()
    try:
        jsonData = json.loads(data)
        if(type(jsonData) == int):
            return 'Cannot post only int'
    except ValueError:
        return "Error type"
    #print(jsonData)
    #restart the cursor
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    #get how many data is already in database
    cursor.execute("select count(*) from Focal_Detail")
    count_id = str(cursor.fetchone()[0])
#     print("insert into Focal_Detail (x, y, z, distance) Values (\"{}\", \"{}\", \"{}\", \"{}\")".format(float(jsonData['x']), float(jsonData['y']), float(jsonData['z']), float(jsonData['distance'])))
    cursor.execute("insert into Focal_Detail (x, y, z, distance, id) Values ({}, {}, {}, {}, {})".format(float(jsonData['x']), float(jsonData['y']), float(jsonData['z']), float(jsonData['distance']), int(count_id)))
    print("insert completed")
    #cursor.close()
    db.commit()
    db.close()
    return json.dumps({"status":"seccess"},indent = 1,ensure_ascii=False).encode('utf8')

@app.route('/uploadImage', methods = ['Post'])
def uploadImage():
    print("upload image")
    #each real object have different size and each size have their own floder
    #you should change this floder whenever you upload new real object image
    #sizeDir = '3_170_120/'
    image = request.files['image']
    if image:
        db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
        cursor = db.cursor()
        cursor.execute("select count(*) from Focal_Detail")
        
        imageNum = cursor.fetchone()[0] - 1
        print(str(imageNum) + ".jpg")
        #if floder already have 5 file return 5
#         imageNum = len(os.listdir(app.config['UPLOAD_FOLDER'] + '/fixImage/'))
        filename = str(imageNum) + ".jpg"
        #print(app.config['UPLOAD_FOLDER'] + "/distanceImage" + "/" + filename)
        #image.save(app.config['UPLOAD_FOLDER'] + "/distanceImage" + "/" + sizeDir + filename)
        image.save(app.config['UPLOAD_FOLDER'] + "/distanceImage" + '/verticalImage/' + filename)
        #cursor.close()
        #db.close()
    return json.dumps({'upload':True, 'name' : filename}, indent = 1,ensure_ascii=False).encode('utf8')

# Bianbang 
labelsPath="/flask-app/yolov4/VOC2020/darknetFile/Bianbang.names"
cfgpath="/flask-app/yolov4/VOC2020/darknetFile/yolo-Bianbang.cfg"
wpath="/flask-app/yolov4/VOC2020/darknetFile/backup/yolo-Bianbang_final.weights"

#100FOOD
# labelsPath="/flask-app/yolov4/FOOD100/darknetFile/food100.names"
# cfgpath="/flask-app/yolov4/FOOD100/darknetFile/yolov4-food100.cfg"
# wpath="/flask-app/yolov4/FOOD100/darknetFile/backup/yolov4-food100_147000.weights"

Lables=yolov4Prediction.get_labels(labelsPath)
CFG=yolov4Prediction.get_config(cfgpath)
Weights=yolov4Prediction.get_weights(wpath)
nets=yolov4Prediction.load_model(CFG,Weights)
Colors=yolov4Prediction.get_colors(Lables)

# route http posts to this method
@app.route('/uploadImageToPredictFoodClass', methods=['POST'])
def uploadImageToPredictFoodClass():
    print("uploadImageToPredictFoodClass")
    # load our input image and grab its spatial dimensions
    img = request.files['image']
    img.save(app.config['UPLOAD_FOLDER'] + '/food/test2.jpg')
    if img:
        imgPATH=app.config['UPLOAD_FOLDER'] + '/food/test2.jpg'
        img = cv2.imread(imgPATH)
        widthRaito = img.shape[0] / 416
        heightRaito = img.shape[1] / 416
        
        img=cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
        img = cv2.resize(img,(416,416))
        image=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
        classIDs,x,y,w,h,res=yolov4Prediction.get_predection(image,nets,Lables,Colors)
        cv2.imwrite(app.config['UPLOAD_FOLDER'] + '/food/test2_box.jpg', res)
        print(str(classIDs)+","+str(x)+","+str(y)+","+str(w)+","+str(h))
        
        return json.dumps({'upload':True, 'classIDs' : classIDs, 'x' : x, 'y' : y, 'w' : w * widthRaito, 'h' : h * heightRaito}, indent = 1,ensure_ascii=False).encode('utf8')
    
@app.route('/getRestaurantMenu', methods=['POST'])
def getRestaurantMenu():
    data = request.get_data()
    try:
        jsondata = json.loads(data)
    except ValueError:
        return "Error type"
    name = jsondata['name']
    print(name)
    db = pymysql.connect(host="db" ,user="root",passwd="050042",db="Help_Heal_Healthy")
    cursor = db.cursor()
    cursor.execute("select item from Menu where Menu.shop=\"{}\"".format("微風鐵板燒"))
#     print(cursor.fetchone())
    data = [item[0] for item in cursor.fetchall()]
    return json.dumps({'menu':data}, indent = 1,ensure_ascii=False).encode('utf8')
    
if __name__ == '__main__':
    app.run(debug=True,port=8888,host="0.0.0.0")