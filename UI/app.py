from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="YOUR_MYSQL_PASSWORD"                                                                                                                                                database="gym_management"
    )

@app.route("/")
def home():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM Member")
    members = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("index.html", members=members)


@app.route("/add", methods=["POST"])
def add_member():
    name = request.form["name"]
    phone = request.form["phone"]
    email = request.form["email"]
    gender = request.form["gender"]
    join_date = request.form["join_date"]

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO Member
        (name, phone, email, gender, join_date, status)
        VALUES (%s, %s, %s, %s, %s, 'Active')
    """, (name, phone, email, gender, join_date))

    db.commit()

    cursor.close()
    db.close()

    return redirect("/")


@app.route("/delete/<int:member_id>")
def delete_member(member_id):
    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Member WHERE member_id = %s",
        (member_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)
