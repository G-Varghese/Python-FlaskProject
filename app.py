
from flask import Flask, flash
from flask import render_template
from flask import request
from flask import redirect, session
from flask import url_for
import re
from datetime import datetime
from datetime import date
import mysql.connector
from mysql.connector import FieldType
import connect
import emailConfig
import ast
import datetime
import re
from flask_mail import Mail, Message


app = Flask(__name__)
app.secret_key = 'any key'

dbconn = None
connection = None

# Email Connection
def getEmail():
    app.config['MAIL_SERVER'] = emailConfig.mailServer
    app.config['MAIL_PORT'] = emailConfig.mailPort
    app.config['MAIL_USE_SSL'] = emailConfig.mailSSL
    app.config['MAIL_USERNAME'] = emailConfig.mailUserName
    app.config['MAIL_PASSWORD'] = emailConfig.mailPWD
    app.config['MAIL_DEFAULT_SENDER'] = emailConfig.mailUserName

    global mail
    mail = Mail(app)
    return mail

def getCursor():
    global dbconn
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, \
    password=connect.dbpass, host=connect.dbhost, \
    database=connect.dbname, autocommit=True)
    dbconn = connection.cursor()
    return dbconn

# Homepage and shared functions

@app.route("/")
def home():
    return render_template("home.html")

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/contact")
def contact():
    return render_template("contact.html")

@app.route("/login", methods=['GET', 'POST'])
def login():
    connection = getCursor()
    connection.execute("SELECT * FROM user;")
    userlist = connection.fetchall()
    return render_template("login.html", userList = userlist)
  
@app.route("/loginuser", methods=['GET','POST'])
def userlogin():  
    try:
     user_name=request.form.get('username')
     user_password=request.form.get('password')
     print(user_name)
     session['user_name']=user_name
     session['user_password']=user_password
     connection = getCursor()
     connection.execute("SELECT * FROM user where username=%s and password=%s",(user_name,user_password))
     type = connection.fetchone()
     var=type[4]
     print(var)
    
     if var==0:
        return redirect(url_for('manager'))
     elif var==1:
        return redirect(url_for('trainer'))
     elif var==2:
        return redirect(url_for('member'))
    except: 
     flash('Invalid Username and Password')
    return render_template("login.html")
 

@app.route("/logout", methods=['GET', 'POST'])
def logout():
    return render_template('home.html')

@app.route("/groupclass", methods=['GET', 'POST'])
def groupclass():
    connection = getCursor()
    connection.execute("SELECT * FROM groupclass;;")
    groupclass = connection.fetchall()
    return render_template("groupclass.html", groupClass = groupclass)

@app.route("/manager", methods=['GET', 'POST'])
def manager():
    return render_template('manager.html')

@app.route("/email", methods=['GET', 'POST'])
def email():
    return render_template("manager_message.html")

@app.route("/send_email", methods=['GET','POST'])
def send_email():
    subject = request.form.get('subject')
    messageContent = request.form.get('message')
    recipients = request.form.get('recipients')
    message = Message(subject=subject, sender="lincolnfitnesscentre@gmail.com", recipients=[recipients], body= messageContent)
    mail = getEmail()
    mail.send(message)
    return "Email sent!"

@app.route("/manager/add", methods=['GET', 'POST'])
def manager_add():
    return render_template('manager_addauser.html')

@app.route("/manager/report", methods=['GET'])
def report():
    return render_template('report.html')

@app.route("/manager/dailyreport", methods=['GET'])
def dailyreport():
    connection = getCursor()
    connection.execute("SELECT payment_date,sum(payment_amount) as total_amount FROM payment group by payment_date;")
    amount = connection.fetchall()
    return render_template("dailyreport.html", Amount = amount)

@app.route("/manager/monthlyreport", methods=['GET'])
def monthlyreport():
    connection = getCursor()
    connection.execute("select extract(year from payment_date),extract(month from payment_date), sum(payment_amount) from payment group by extract(year from payment_date),extract(month from payment_date);")
    amount = connection.fetchall()
    return render_template("monthlyreport.html", Amount = amount)

@app.route("/manager/yearlyreport", methods=['GET'])
def yearlyreport():
    connection = getCursor()
    connection.execute("select extract(year from payment_date) as yearpayment, sum(payment_amount) from payment group by yearpayment;")
    amount = connection.fetchall()
    return render_template("yearlyreport.html", Amount = amount)

@app.route("/manager_addauser", methods=['GET', 'POST'])
def manager_addauser():
    username = request.form.get('username')
    password = request.form.get('password')
    securityanswer = request.form.get('securityanswer')
    sql = """INSERT INTO user (username, password, securityanswer, user_type)
            VALUES (%s, %s, %s, '2');"""
    parameters= (username, password, securityanswer)
    cur = getCursor()
    cur.execute(sql, parameters)
    return redirect('/manager_usercreated')

@app.route("/manager_usercreated", methods=['GET','POST']) 
def manager_usercreated(): 
    connection = getCursor()
    sql=""" SELECT * FROM user
            ORDER BY user_id DESC
            LIMIT 1;"""
    connection.execute(sql)
    newuserinfo = connection.fetchall()
    return render_template("manager_usercreated.html", newuser = newuserinfo)

@app.route("/manager/addamember", methods=['GET','POST']) 
def addamember():
    return render_template('manager_addamember.html')

@app.route("/manager_addamember", methods=['GET','POST']) 
def manager_addamember():
    user_id = request.form.get('userid')
    #  to get the rest of the values from user input 
    member_name = request.form.get('member_name')
    member_gender = request.form.get('member_gender')
    member_dob = request.form.get('member_dob')
    member_joindate = date.today()
    member_houseaddress = request.form.get('member_houseaddress')
    member_suburb = request.form.get('member_suburb')
    member_city = request.form.get('member_city')
    member_postalcode = request.form.get('member_postalcode')
    member_phone = request.form.get('member_phone')
    member_email = request.form.get('member_email')
    #  use %s as a placeholder
    sql = """INSERT INTO members (user_id, member_name, member_gender, member_dob, member_status,
            member_joindate, member_houseaddress, member_suburb, member_city, member_postalcode,
            member_phone, member_email)
            VALUES (%s, %s, %s, %s, 'Active', %s, %s, %s, %s, %s, %s, %s);"""
    parameters= (user_id, member_name, member_gender, member_dob, member_joindate, member_houseaddress,
                member_suburb, member_city, member_postalcode, member_phone, member_email)
    cur = getCursor()
    cur.execute(sql, parameters)   
    return redirect("/manager_members")

@app.route("/manager_members", methods=['GET','POST']) 
def manager_members():
    connection = getCursor()
    sql= """SELECT * FROM members ORDER BY user_id;"""
    connection.execute(sql)
    memberList = connection.fetchall()
    return render_template("manager_members.html", memberlist = memberList) 

@app.route("/manager/update", methods=['GET', 'POST'])
def manager_update():
    connection = getCursor()
    sql= """SELECT * FROM members ORDER BY user_id;"""
    connection.execute(sql)
    memberList = connection.fetchall()
    return render_template('manager_update.html', memberlist = memberList)

@app.route("/manager_searchmember", methods=["POST"])
def manager_searchmember():
# to get user input as the search term
    searchterm = request.form.get('manager_searchmember')
    searchterm = "%" + searchterm + "%"
    connection = getCursor()
    connection.execute("SELECT * FROM members WHERE member_name LIKE %s;",(searchterm,))
    searchmemberList = connection.fetchone()
    print(searchmemberList)
    return render_template("manager_viewmember.html", searchmemberlist = searchmemberList)

@app.route("/manager_searchmemberid", methods=["POST"])
def manager_searchmemberid():
# to get user input as the search term
    searchterm = request.form.get('manager_searchmemberid')
    searchterm = "%" + searchterm + "%"
    connection = getCursor()
    connection.execute("SELECT * FROM members WHERE member_id LIKE %s;",(searchterm,))
    searchmemberList = connection.fetchone()
    print(searchmemberList)
    return render_template("manager_viewmember.html", searchmemberlist = searchmemberList)

@app.route("/manager_memberedit", methods=['POST'])
def manager_memberedit():
    mid=request.form.get('memberid')
    print(mid)
    print(mid)
    connection = getCursor()
    connection.execute("SELECT * FROM members where member_id=%s;",(mid,))
    memberList=connection.fetchone()
    return render_template("manager_memberupdate.html",memberlist=memberList)


@app.route("/manager_memberupdate", methods=['GET', 'POST'])
def manager_memberupdate():
    connection = getCursor()
    memberid = request.form.get('mid')
    print(memberid)
    gender = request.form.get('gender')
    dob = request.form.get('dob')
    status= request.form.get('status')
    joindate= request.form.get('joindate')
    lastpaydate = request.form.get('lastpaydate')
    houseno = request.form.get('houseno')
    suburb = request.form.get('suburb')
    city=request.form.get('city')
    postalcode = request.form.get('postalcode')
    phone = request.form.get('phone')
    email=request.form.get('email')
    connection.execute("SELECT * FROM members;")
    cur = getCursor()
    cur.execute("""UPDATE members
                        SET member_gender = %s, member_dob = %s, member_status = %s, member_joindate= %s,
                            member_lastpaydate = %s, member_houseaddress = %s, member_suburb = %s, member_city = %s, member_postalcode = %s, member_phone = %s, member_email = %s
                        WHERE member_id = %s;""",
                (gender, dob, status, joindate, lastpaydate, houseno, suburb, city, postalcode, phone, email, memberid,))
    return redirect("/manager_members")


@app.route("/manager_pay", methods=['GET', 'POST'])
def manager_pay():
    connection = getCursor()
    connection.execute("""SELECT * FROM payment JOIN members ON payment.member_id = members.member_id 
                        ORDER BY payment.payment_date DESC, payment.payment_id DESC;""")
    paymentList = connection.fetchall()
    return render_template('manager_payment.html', paymentlist = paymentList)

@app.route("/manager_payment", methods=['GET', 'POST'])
def manager_payment():
    member_lastpaydate = date.today()
    member_id = request.form.get('member_id')
    memberid = request.form.get('member_id')
    paymentamount = request.form.get('amount')
    paymentdescription = request.form.get('subscriptiontype')
    paymentdate = date.today()
    
    sql1 = """UPDATE members SET member_lastpaydate = %s WHERE member_id = %s;"""
    parameters1= (member_lastpaydate, member_id)
   
  
    sql2 = """INSERT INTO payment(member_id, payment_amount, payment_description, payment_date)
            VALUES(%s, %s, %s, %s);"""
    parameters2= (memberid, paymentamount, paymentdescription, paymentdate)        
    cur = getCursor()
    cur.execute(sql1, parameters1)
    cur.execute(sql2, parameters2)

    connection = getCursor()
    connection.execute("""SELECT * FROM payment JOIN members ON payment.member_id = members.member_id 
                        ORDER BY payment.payment_date DESC, payment.payment_id DESC;""")
    paymentList = connection.fetchall()
    return render_template('manager_paymentlist.html', paymentlist = paymentList)



@app.route("/manager_attendance", methods=['GET', 'POST'])
def manager_attendance():
    

    connection = getCursor()
    connection.execute("""SELECT * FROM attendance JOIN members ON attendance.member_id = members.member_id
                        ORDER BY attendance.attendance_date ASC, attendance.swipe_in ASC;""")
    attendanceList = connection.fetchall()
  
    return render_template("manager_attendance.html", attendancelist = attendanceList)

@app.route("/manager_searchattendance", methods=['GET', 'POST'])
def manager_searchattendance():
    searchterm = request.form.get('member_name')
    searchterm = "%" + searchterm + "%"
    connection = getCursor()
    connection.execute("""SELECT * FROM attendance JOIN members ON attendance.member_id = members.member_id
                        WHERE members.member_name LIKE %s
                        ORDER BY attendance.attendance_date ASC, attendance.swipe_in DESC;""",(searchterm,))
    searchMember = connection.fetchall()
    print(searchMember)
    return render_template("manager_viewattendance.html", searchmember = searchMember)

@app.route("/manager/lessons", methods=['GET','POST'])
def manager_viewlessons():
    connection = getCursor()
    connection.execute("""SELECT * FROM groupclasssession join groupclass 
    on groupclasssession.groupclass_id = groupclass.groupclass_id;""")
    lessonList = connection.fetchall()
    return render_template('manager_viewlessons.html', lessonlist = lessonList)

@app.route("/manager/lessons/booked", methods=['GET','POST'])
def manager_viewlessonsbooked():
    connection = getCursor()
    connection.execute("""SELECT * FROM groupclassbooking join groupclasssession 
    on groupclassbooking.groupclasssession_id=groupclasssession.groupclasssession_id join members 
    on groupclassbooking.member_id=members.member_id;""")
    bookList = connection.fetchall()
    return render_template('manager_viewlessonsbooked.html', booklist = bookList)

@app.route("/manager/sessions", methods=['GET','POST'])
def manager_viewsessions():
    connection = getCursor()
    connection.execute("""SELECT * FROM personalbooking join personaltrainingsession 
    on personalbooking.personaltrainingsession_id=personaltrainingsession.personaltrainingsession_id 
    join personaltraining on personaltrainingsession.personaltraining_id=personaltraining.personaltraining_id
    join members on personalbooking.member_id=members.member_id;""")
    sessionList = connection.fetchall()
    return render_template('manager_veiwsessions.html', sessionlist = sessionList)

@app.route("/manager/subscription", methods=['GET', 'POST'])
def manager_subscription():
    connection = getCursor()
    sql= """SELECT member_id as MemberID,member_name as Name,
    member_email as Email,member_lastpaydate as LastPayDate,
    member_status as Status from members
    ORDER BY member_id;"""
    connection.execute(sql)
    membersList = connection.fetchall()
    return render_template('manager_subscription.html',memberslist = membersList)

# create a due soon list where subscription will due in 7 days 
@app.route("/manager/duesoon", methods=['GET','POST']) 
def manager_duesoon():
    connection = getCursor()
    sql= """SELECT member_id as MemberID, member_name as Name,
       member_email as Email, member_lastpaydate as LastPayDate
    FROM members 
    WHERE DATEDIFF(DATE_ADD(member_lastpaydate, INTERVAL 30 DAY), NOW()) <= 7
    AND member_lastpaydate >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    ORDER BY member_id;"""
    connection.execute(sql)
    membersList = connection.fetchall()
    return render_template("manager_duesoon.html", memberslist = membersList) 

# create a overdue list where subscription expired 
@app.route("/manager/overdue", methods=['GET','POST'])
def manager_overdue():
    connection = getCursor()
    sql=""" SELECT member_id as MemberID,member_name as Name,
    member_email as Email,member_lastpaydate as LastPayDate, 
    member_status as Status FROM members
    Where DATEDIFF(NOW(), member_lastpaydate) >30
    ORDER BY member_id;"""
    connection.execute(sql)
    membersList = connection.fetchall()
    return render_template("manager_overdue.html", memberslist = membersList) 

@app.route("/overduemember")
def overduemember():
    connection = getCursor()
    sql=""" select * from (
                SELECT
                member_ID as memberId, member_email, member_name,
                member_lastpaydate,
                DATEDIFF(NOW(), member_lastpaydate) AS days_since_last_payment
                FROM members
        ) temp where days_since_last_payment > 30;"""
    connection.execute(sql)
    memberList = connection.fetchall()
    return render_template("manager_duereminder.html", memberlist = memberList) 

@app.route('/overdue_row', methods=['POST'])
def overdue_row():

    memberListStr = request.form['memberlist']
    # print(memberListStr)
    member_list = memberListStr.split("), (")


    for member in member_list:
        print(member)
        member_info = member.replace("'", "").replace("[(", "").replace(")]", "")
        print(member_info)
        match = re.search(r'datetime\.date\((\d{4}), (\d{1,2}), (\d{1,2})\)', member_info)
        if match:
            year, month, day = match.group(1, 2, 3)
            lastPaidDate = datetime.date(int(year), int(month), int(day)).strftime('%Y-%m-%d')
            print(lastPaidDate)

        info = member_info.split(", ")
        userEmail = info[1]
        userName = info[2]
        overDate = info[6]
        recipients = [userEmail, "superyue0401@gmail.com"] # add meself to a check
        subject = "Overdue Payment Reminder for " + userName
        email_body = "Dear "+ userName+ "\n\nThis is a friendly reminder that your payment was at " + lastPaidDate + " and now is overdue " + overDate+" days. \n\nWe kinderly remind you to make your payment as soon as possible to avoid any disruption to your membership. Please note that your membership benefits, including access to the gym and group fitness classes, may be suspended until your payment is received. We want to ensure that all members have equal access to our facilities and services, and we appreciate your prompt attention to this matter.  "+ "\n\nIf you have any questions or concerns about your membership, please do not hesitate to contact us. Our team is here to help you. Thank you for choosing Lincoln Fitness Centre as your fitness destination.\n\nBest regards, \n\nLincoln Fitness Centre"
        message = Message(subject=subject, sender="lincolnfitnesscentre@gmail.com", recipients=recipients, body= email_body)
        mail = getEmail()
        mail.send(message)

    return "Overdue Email Send. "

@app.route("/manager_viewpopularclass")
def manager_viewpopularclass():
    connection = getCursor()
    sql=""" select groupclass.groupclass_id, groupclass.groupclass_name, groupclasssession.groupclasssession_id, COUNT(groupclassbooking.groupclasssession_id) AS num_booking
FROM groupclass
INNER JOIN groupclasssession ON groupclass.groupclass_id=groupclasssession.groupclass_id
INNER JOIN groupclassbooking ON groupclasssession.groupclasssession_id=groupclassbooking.groupclasssession_id
GROUP BY 
    groupclass.groupclass_id, 
    groupclass.groupclass_name,
    groupclasssession.groupclasssession_id
HAVING 
    COUNT(groupclassbooking.groupclasssession_id) > 1;"""
    connection.execute(sql)
    popularclasslist = connection.fetchall()
    return render_template("manager_viewpopularclass.html", popularclasslist = popularclasslist) 

# Functions for Member start

@app.route("/member", methods=['GET', 'POST'])
def member():
    userid=request.form.get('id')
    print(userid)
    session['userid'] = userid
    return render_template('member.html')

@app.route("/member/memberprofile",methods=['GET', 'POST'])
def memberprofile():  
    usern=session.get('user_name')
    connection = getCursor()
    connection.execute("SELECT * FROM members join user on user.user_id=members.user_id where user.username=%s;",(usern,))
    memberList=connection.fetchone()
    connection.execute("SELECT personaltraining.personaltraining_name,personaltrainingsession.date,personaltrainingsession.time FROM members join user on user.user_id=members.user_id join personalbooking on personalbooking.member_id=members.member_id join personaltrainingsession on personaltrainingsession.personaltrainingsession_id=personalbooking.personaltrainingsession_id join personaltraining on personaltraining.personaltraining_id=personaltrainingsession.personaltraining_id where user.username=%s;",(usern,))
    sclass=connection.fetchall()
    connection.execute("SELECT groupclass.groupclass_name, groupclasssession.groupclass_date,groupclasssession.groupclass_time FROM members join user on user.user_id=members.user_id join groupclassbooking on groupclassbooking.member_id=members.member_id join groupclasssession on groupclasssession.groupclasssession_id=groupclassbooking.groupclasssession_id join groupclass on groupclass.groupclass_id=groupclasssession.groupclass_id where user.username=%s;",(usern,))
    gclass=connection.fetchall()
    return render_template("memberprofile.html",memberlist=memberList,special=sclass,group=gclass)

@app.route("/member/memberedit", methods=['POST'])
def memberedit():
    mid=request.form.get('memberid')
    connection = getCursor()
    connection.execute("SELECT * FROM members where member_id=%s;",(mid,))
    memberList=connection.fetchone()
    print(memberList[3])
    return render_template("memberupdate.html",memberlist=memberList)

@app.route("/member/memberupdate", methods=['POST'])
def updatemember():
    connection = getCursor()
    memberid = request.form.get('mid')
    gender = request.form.get('gender')
    dob = request.form.get('dob')
    status= request.form.get('status')
    joindate= request.form.get('joindate')
    lastpaydate = request.form.get('lastpaydate')
    houseno = request.form.get('houseno')
    suburb = request.form.get('subrub')
    city=request.form.get('city')
    postalcode = request.form.get('postalcode')
    phone = request.form.get('phone')
    email=request.form.get('email')
    connection.execute("SELECT * FROM members;")
    cur = getCursor()
    cur.execute("""UPDATE members
                        SET member_gender=%s,member_dob=%s,member_status=%s,member_joindate=%s,
                            member_lastpaydate=%s,member_houseaddress=%s,member_suburb=%s,member_city=%s,member_postalcode=%s,member_phone=%s,member_email=%s
                        WHERE member_id=%s;""",
                (gender,dob,status,joindate,lastpaydate,houseno,suburb,city,postalcode,phone,email,memberid,))
    flash('Member details Updated')
    return redirect("/member/memberprofile")

@app.route("/member/changepassword", methods=['GET', 'POST'])
def changepassword():
    return render_template('changepassword.html')

@app.route("/member/updatepassword", methods=['POST'])
def updatepassword():
    connection = getCursor()
    usern=session.get('user_name')
    print(usern)
    password = request.form.get('password')
    confirm = request.form.get('confirm')
    print(password)
    connection.execute("SELECT * FROM user;")
    cur = getCursor()

    if password == confirm:
       cur.execute("""UPDATE user
                        SET password=%s
                        WHERE username=%s;""",
                (password,usern,))
       flash('Password updated successfully!Login again')
       return redirect("/login")
    else:
      flash('New password and confirm password do not match')
      return render_template('changepassword.html') 
    

@app.route("/member/viewtrainer", methods=['GET', 'POST'])
def member_viewtrainer():
    connection = getCursor()
    connection.execute("SELECT * FROM trainers;")
    trainerslist = connection.fetchall()
    return render_template("member_viewtrainer.html", trainersList = trainerslist)

@app.route("/member/viewtrainer/trainerdetail", methods=['GET','POST'])
# This route is only accessed from member_viewtrainer page
def member_viewtrainer_trainerdetail():
    trainerid = request.form.get('trainerid')
    connection = getCursor()
    connection.execute("""SELECT * FROM trainers join personaltraining 
    on trainers.trainer_id = personaltraining.trainer_id where trainers.trainer_id = %s;""",(trainerid,))
    trainerdetail = connection.fetchall()
    return render_template("member_viewtrainer_trainerdetail.html", trainerDetail = trainerdetail)

@app.route("/member/groupclass", methods=['GET', 'POST'])
def member_groupclass():
    connection = getCursor()
    connection.execute("SELECT * FROM groupclass;;")
    groupclass = connection.fetchall()
    return render_template("member_groupclass.html", groupClass = groupclass)

@app.route("/member/groupclass/book", methods=['GET','POST'])
def groupclass_book():
    connection = getCursor()
    connection.execute("""SELECT * FROM groupclass join groupclasssession on 
    groupclass.groupclass_id = groupclasssession.groupclass_id;""")
    groupclass = connection.fetchall()
    return render_template("member_groupclass_book.html", groupClass = groupclass)

@app.route("/member/groupclass/booked", methods=['GET','POST'])
def groupclass_booked():
    book_memberid = request.form.get('inputid')
    groupclasssession_id = request.form.get('groupclasssessionid')
    status = "Confirmed"
    connection = getCursor()
    sql = """INSERT INTO groupclassbooking (member_id, groupclasssession_id, groupclassbooking_status) 
    VALUES (%s, %s,%s);"""
    connection.execute(sql,(book_memberid, groupclasssession_id, status,))
    return "Lesson Booked!"

@app.route("/member/bookpersonal", methods=['GET','POST'])
def member_bookpersonal():
    connection = getCursor()
    connection.execute("""SELECT * FROM personaltraining join personaltrainingsession on 
    personaltraining.personaltraining_id = personaltrainingsession.personaltraining_id 
    where personaltrainingsession.status = 'Available';""")
    bookpersonal = connection.fetchall()
    return render_template("member_bookpersonal.html", bookPersonal = bookpersonal)

@app.route("/member/bookpersonal/booked", methods=['GET','POST'])
def member_bookpersonal_booked():
    book_memberid = request.form.get('input_id')
    book_perseshid = request.form.get('persessh_id')
    connection = getCursor()
    sql = """INSERT INTO personalbooking (member_id, personaltrainingsession_id) 
    VALUES (%s, %s);"""
    connection.execute(sql,(book_memberid, book_perseshid,))
    return "Session Booked!"

@app.route("/member/booking", methods=['GET','POST'])
def member_booking():
    connection = getCursor()
    connection.execute("""SELECT * FROM personaltraining join personaltrainingsession on 
    personaltraining.personaltraining_id = personaltrainingsession.personaltraining_id 
    where personaltrainingsession.status = 'Available';""")
    bookpersonal = connection.fetchall()
    return render_template("member_booking.html", bookPersonal = bookpersonal)

@app.route("/member/cancelbooking/groupcancelled", methods=['GET','POST'])
def member_cancelbooking_groupcencelled():
    book_groupid = request.form.get('groupseshid')
    connection = getCursor()
    connection.execute("""DELETE FROM groupclassbooking where groupclassbooking_id=%s;""",(book_groupid,))
    return "Lesson Cancelled!"

@app.route("/member/cancelbooking/personalcancelled", methods=['GET','POST'])
def member_cancelbooking_persionalcencelled():
    book_persesh_id = request.form.get('persessh_id')
    connection = getCursor()
    connection.execute("""DELETE FROM personalbooking where personalbooking_id=%s;""",(book_persesh_id,))
    return "Session Cancelled!"

# create a payment function for members 
@app.route("/member/pay", methods=['GET', 'POST'])
def member_pay():
    connection = getCursor()
    connection.execute("""SELECT members.member_id, SUM(payment_amount) as total_amount FROM payment 
    JOIN members ON payment.member_id = members.member_id GROUP BY members.member_id;""")              
    paymentList = connection.fetchall()
    return render_template('member_payment.html', paymentlist = paymentList)

@app.route("/member/payment", methods=['GET', 'POST'])
def member_payment():
    member_lastpaydate = date.today()
    mid = request.form.get('member_id')
    memberid = request.form.get('member_id')
    paymentamount = request.form.get('amount')
    paymentdescription = request.form.get('subscriptiontype')
    paymentdate = date.today()
    
    sql1 = """UPDATE members SET member_lastpaydate = %s WHERE member_id = %s;"""
    parameters1= (member_lastpaydate, mid)
   
    sql2 = """INSERT INTO payment(member_id, payment_amount, payment_description, payment_date)
            VALUES(%s, %s, %s, %s);"""
    parameters2= (memberid, paymentamount, paymentdescription, paymentdate)        
    cur = getCursor()
    cur.execute(sql1, parameters1)
    cur.execute(sql2, parameters2)
    return redirect('/member/confirmation')

@app.route('/member/confirmation')
def confirmation_page():
    return render_template('confirmation_page.html')

# Functions for Trainer start
@app.route("/trainer", methods=['GET', 'POST'])
def trainer():
    userid=request.form.get('id')
    print(userid)
    session['userid'] = userid
    return render_template("trainer.html")

@app.route("/trainer/profile", methods=['GET', 'POST'])
def trainer_profile():
    tid = request.form.get('trainerid')
    connection = getCursor()
    connection.execute("""SELECT * FROM trainers join personaltraining on 
    trainers.trainer_id = personaltraining.trainer_id where trainers.trainer_id = %s;""",(tid,))
    profilelist = connection.fetchall()
    return render_template("trainer_profile.html", profileList = profilelist)

@app.route("/trainer/viewtrainee", methods=['GET', 'POST'])
def viewtrainee():
    connection = getCursor()
    connection.execute("""SELECT member_id,member_name,member_gender, DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), member_dob)), '%Y') + 0 AS age,
    member_phone from members;""")
    memberslist = connection.fetchall()
    return render_template("trainer_viewtrainee.html", membersList = memberslist)

# trying to click the name to link to the member detail page 
@app.route("/trainer/viewtrainee/detail", methods=['GET', 'POST'])
def trainer_viewtrainee_details():
    memberid = request.form.get('member_id')
    connection = getCursor()
    connection.execute("""SELECT * from members WHERE member_id = %s;""",(memberid,))
    memberdetail = connection.fetchall()
    return render_template("trainer_viewtrainee_details.html", memberDetail = memberdetail)

# functions for searching trainee by names, allowing partial searching 
@app.route("/searchtrainee", methods=["POST"]) 
def search_trainee():
    searchname = request.form.get("searchname")
    searchname = "%" + searchname + "%" 
    connection = getCursor()
    sql="""SELECT member_id,member_name,member_gender, DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), member_dob)), '%Y') + 0 AS age,
    member_phone FROM members WHERE member_name LIKE %s;"""
    connection.execute(sql,(searchname,))
    memberslist = connection.fetchall()
    return render_template("trainer_viewtrainee.html", membersList = memberslist)

@app.route("/trainer/searchtrainerid", methods=["POST"])
def trainer_searchtrainerid():
    tid = request.form.get('trainerid')
    connection = getCursor()
    connection.execute("""SELECT * FROM trainers join personaltraining on 
    trainers.trainer_id = personaltraining.trainer_id where trainers.trainer_id = %s;""",(tid,))
    profilelist = connection.fetchall()
    return render_template("trainer_profile.html", profileList = profilelist)

@app.route("/trainer/trainers", methods=['GET','POST']) 
def trainer_trainers():
    connection = getCursor()
    connection.execute("""SELECT * FROM trainers join user on user.user_id=trainers.user_id
    join personaltraining on trainers.trainer_id = personaltraining.trainer_id 
    ;""")
    profilelist=connection.fetchall()
    return render_template("trainer_trainers.html",profileList = profilelist)

@app.route("/trainer/update", methods=['GET', 'POST'])
def trainer_update():
    return render_template('trainer_update.html')
    
@app.route("/trainer/edit",methods=['POST'])
def trainer_edit():
    tid = request.form.get('trainerid')
    print(tid)
    connection = getCursor()
    connection.execute("SELECT * FROM trainers where trainer_id=%s;",(tid,))
    profilelist = connection.fetchone()
    return render_template("trainer_updateinfo.html",profileList = profilelist)

@app.route("/trainer/updateinfo", methods=['GET','POST'])
def trainer_updateinfo():
    connection = getCursor()
    trainer_id = request.form.get('trainer_id')
    print(trainer_id)
    trainer_name = request.form.get('trainer_name')
    trainer_gender = request.form.get('trainer_gender')
    trainer_phone = request.form.get('trainer_phone')
    trainer_email = request.form.get('trainer_email')
    trainer_dob = request.form.get('trainer_dob')
    trainer_houseno = request.form.get('trainer_houseno')
    trainer_city = request.form.get('trainer_city')
    trainer_specialization = request.form.get('trainer_specialization')
    trainer_qualification = request.form.get('trainer_qualification')
    trainer_certification = request.form.get('trainer_certification')
    connection.execute("SELECT * FROM trainers;")
    sql = """UPDATE trainers SET trainer_name = %s, trainer_gender = %s, trainer_phone = %s,
         trainer_email = %s, trainer_dob = %s, trainer_houseno = %s, trainer_city = %s, 
         trainer_specialization = %s, trainer_qualification = %s, trainer_certification = %s
        WHERE trainer_id = %s;"""   
    parameters= (trainer_name, trainer_gender, trainer_phone, trainer_email, trainer_dob, trainer_houseno,
                trainer_city,trainer_specialization, trainer_qualification,trainer_certification,trainer_id)
    cur = getCursor()
    cur.execute(sql, parameters)
    return redirect("/trainer/trainers")
