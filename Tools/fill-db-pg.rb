#! /usr/bin/ruby -w

require "rubygems"
require "pg"

DB = PG::Connection.open(:dbname => "jd-test-db", :user => "jd")
#DB.connect(host="46.51.161.221", user='root', port="3306")

#DB.query("CREATE TABLE test.testtable(title VARCHAR(15), givenname VARCHAR(25), surname VARCHAR(25), dateofbirth DATE() );")

titles = ['mr','mrs','miss','ms','dr','prof']
givens = ['albert','barnard','christopher','david','edward','frederick','george','harold','ignatius','james','kenneth','leonard','mark','norman','owen','peter','quentin','robert','stephen','terrence','ulysses','victor','william','xavier','zachariah']
surnames = [ 'SMITH', 'JONES', 'WILLIAMS', 'BROWN', 'TAYLOR', 'DAVIES', 'WILSON', 'EVANS', 'THOMAS', 'JOHNSON', 'ROBERTS', 'WALKER', 'WRIGHT', 'ROBINSON', 'THOMPSON', 'WHITE', 'HUGHES', 'EDWARDS', 'GREEN', 'HALL', 'WOOD', 'HARRIS', 'LEWIS', 'MARTIN', 'JACKSON', 'CLARKE', 'CLARK', 'TURNER', 'HILL', 'SCOTT', 'COOPER', 'MORRIS', 'WARD', 'MOORE', 'KING', 'WATSON', 'BAKER', 'HARRISON', 'MORGAN', 'PATEL', 'YOUNG', 'ALLEN', 'MITCHELL', 'JAMES', 'ANDERSON', 'PHILLIPS', 'LEE', 'BELL', 'PARKER', 'DAVIS', 'BENNETT', 'MILLER', 'COOK', 'PRICE', 'CAMPBELL', 'SHAW', 'GRIFFITHS', 'KELLY', 'RICHARDSON', 'SIMPSON', 'CARTER', 'COLLINS', 'MARSHALL', 'BAILEY', 'GRAY', 'STEWART', 'COX', 'MURPHY', 'ADAMS', 'MURRAY', 'RICHARDS', 'ELLIS', 'ROBERTSON', 'WILKINSON', 'FOSTER', 'GRAHAM', 'CHAPMAN', 'MASON', 'RUSSELL', 'POWELL', 'WEBB', 'ROGERS', 'HUNT', 'MILLS', 'HOLMES', 'OWEN', 'PALMER', 'MATTHEWS', 'GIBSON', 'FISHER', 'THOMSON', 'BARNES', 'KNIGHT', 'LLOYD', 'HARVEY', 'BARKER', 'BUTLER', 'JENKINS', 'REID', 'STEVENS'  ]

1000.times do |loop|
  puts "Starting loop: #{loop}"
  surnames.each do |sname|
    givens.each do |gname|
      titles.each do |title|
        #dob = (1950 + rand(60)).to_s + "-" + rand(12).to_s + "-" + rand(28).to_s
        dob =  sprintf("%4d-%02d-%02d", 1950 + rand(65), 1 + rand(12), 1+rand(27))
        query_string = "INSERT INTO test (title, givenname, surname, dateOfBirth) VALUES ('#{title}', '#{gname}', '#{sname}', '#{dob}');"
        #puts query_string
        DB.exec(query_string)
        sleep 2
      end
    end
  end
end
