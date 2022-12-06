from flask import Flask, render_template, request
from math import sin

APP = Flask(__name__)
HISTORY = []

@APP.route("/")
def home():
    return render_template("index.html", output = "Результат")


@APP.route("/history")
def history():
    return render_template("history.html", history = HISTORY)


@APP.route("/calculate", methods = ["POST"])
def calculate():
    if request.method == "POST":
        num1 = int(request.form["num1"])
        num2 = int(request.form["num2"])
        op = request.form["operation"]

        if op == "+":
            result = num1 + num2
        elif op == "-":
            result = num1 - num2
        elif op == "*":
            result = num1 * num2
        elif op == "/":
            result = num1 / num2
        elif op == "sin":
            result = sin(num1)
        if op != "sin":
            HISTORY.append([ str(num1) + op + str(num2), result ])
        else:
            HISTORY.append([ str(num1) + op, result ])

        return render_template("index.html", output = result)

if __name__ == "__main__":
    APP.run()