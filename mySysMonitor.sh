#! /bin/bash

: > Linux-System-Monitor.html
: > ${HOME}/Linux_System_Monitor/Linux-System-Monitor.log

#Author : - Virendra Vyas
#Declaring variables

#Making log file for Current Processes

log="${HOME}/Linux_System_Monitor/Linux-System-Monitor.log"


#2) Currently Logged in Users

current_loggedin_user_name=`last | awk {'print$1'} | cut -f1 -d','`

current_loggedin_user_day=`last | awk {'print$3'} | cut -f1 -d','`

current_loggedin_user_date=`last | awk {'print$5'} | cut -f1 -d','`

current_loggedin_user_time=`last | awk {'print$6'} | cut -f1 -d','`

current_loggedin_user_status=`last | awk {'print$2'} | cut -f1 -d','`

#3) Plugged in Devices

plugin_device_name=`lsblk | awk {'print$1'} | tail -n 8`

plugin_device_size=`lsblk | awk {'print$4'} | tail -n 8`

plugin_device_type=`lsblk | awk {'print$6'} | tail -n 8`

plugin_device_mountpoint=`lsblk | awk {'print$7'} | tail -n 8`

#4) Disk Usage

disk_name=`df -h | awk {'print$1'} | tail -n 9`

disk_blocks=`df -h | awk {'print$2'} | tail -n 9`

disk_in_Used=`df -h | awk {'print$3'} | tail -n 9`

disk_available=`df -h | awk {'print$4'} | tail -n 9`

disk_mounted_on=`df -h | awk {'print$6'} | tail -n 9` 


#Home-Directory Usage

home_directory_size=`du -sh /home/* | sort -nr | awk {'print$1'}`

home_directory_location=`du -sh /home/* | sort -nr | awk {'print$2'}`


#Other(Downloads) Directory Usage

other_directory_size=`du -sh /home/virendra29/Downloads | sort -nr | awk {'print$1'}`

other_directory_location=`du -sh /home/virendra29/Downloads | sort -nr | awk {'print$2'}`

#5)Network Interfaces

network_interfaces_status=`ifconfig`

#6)RAM Usage

current_ram_usage=`free -m | head -2 | tail -1 | awk {'print$3'}`

total_ram=`free -m | head -2 | tail -1 | awk {'print$2'}` 

ram_available=`free -m | head -2 | tail -1 | awk {'print$4'}`


#Creating a directory if it doesn't exist to store reports first.

if [ ! -d ${HOME}/Linux_System_Monitor ]

then

  mkdir ${HOME}/Linux_System_Monitor

fi


html="${HOME}/Linux_System_Monitor/Linux_System_Monitor.html"

: > $html

#Generating HTML file

echo "<!DOCTYPE log PUBLIC \"-//W3C//DTD log 4.01 Transitional//EN\" \"http://www.w3.org/TR/log4/loose.dtd\">" >> $html
echo "<html>" >> $html
echo "<head>" >> $html
echo "<title>My System Monitor</title>" >>$html
echo "<style> 
body{background: rgb(0,0,0);background: linear-gradient(90deg, rgba(0,0,0,1) 0%, rgba(23,155,246,1) 0%, rgba(50,149,166,1) 100%, rgba(0,212,255,1) 100%);}

h1{color: #ffffff;}

h2{color: ##43454A; text-align: center; margin-bottom:20px;font-family:\"Lucida Console\", Monaco, monospace;} h3{font-family:\"Lucida Console\", Monaco, monospace; margin-top:25px; margin-bottom:20px; color:#121318;}

p{color: #4e3318;}

a{color: #7c63cf;} 

fieldset{background-image: linear-gradient(to left top, #303137, #54565e, #7c7e89, #a5a8b6, #d1d4e5);}

table.blueTable {
  border: 1px solid #1C6EA4;
  background-color: #EEEEEE;
  width: 100%;
  text-align: left;
  border-collapse: collapse;
}
table.blueTable td, table.blueTable th {
  border: 1px solid #AAAAAA;
  padding: 3px 2px;
}
table.blueTable tbody td {
  font-size: 13px;
}
table.blueTable tr:nth-child(even) {
  background: #D0E4F5;
}
table.blueTable thead {
  background: #1C6EA4;
  background: -moz-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
  background: -webkit-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
  background: linear-gradient(to bottom, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
  border-bottom: 2px solid #444444;
}
table.blueTable thead th {
  font-size: 15px;
  font-weight: bold;
  color: #FFFFFF;
  border-left: 2px solid #D0E4F5;
}
table.blueTable thead th:first-child {
  border-left: none;
}

table.blueTable tfoot {
  font-size: 14px;
  font-weight: bold;
  color: #FFFFFF;
  background: #D0E4F5;
  background: -moz-linear-gradient(top, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
  background: -webkit-linear-gradient(top, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
  background: linear-gradient(to bottom, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
  border-top: 2px solid #444444;
}
table.blueTable tfoot td {
  font-size: 14px;
}
table.blueTable tfoot .links {
  text-align: right;
}
table.blueTable tfoot .links a{
  display: inline-block;
  background: #1C6EA4;
  color: #FFFFFF;
  padding: 2px 8px;
  border-radius: 5px;
}
</style>" >> $html

echo " <script src="http://code.jquery.com/jquery-latest.js"></script>" >> $html
echo "<script> var refreshId = setInterval(function()
{

\$('#responsecontainer').load('Linux-System-Monitor.log');
}, 6000);
 </script>" >>$html

echo "<script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>

    <script type=\"text/javascript\">

      google.charts.load(\"current\", {packages:[\"corechart\"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Task', 'Hours per Day'],
          ['RAM in Use',     $current_ram_usage],
	  ['Available RAM', $ram_available ],
          ['Total RAM',    $total_ram]
        ]);

        var options = {
          pieHole: 0.8,
	  is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
        chart.draw(data, options);
      }
    </script>
" >>$html
echo "</head>" >>$html
echo "<body>" >>$html
echo "<fieldset>" >>$html
echo "<center>" >>$html
echo "<h1><u>Linux System Monitor</u></h1>" >>$html 
echo "</center>" >>$html
echo "</fieldset>" >>$html
echo "<br>" >>$html
echo "<center>" >>$html
echo "<h2><u>1.List of Current Process</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre id="responsecontainer"></pre></td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#---------------------------------------------------------------
echo "<br>">>$html
echo "<h2><u>2.Currently Login Users</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Login User Name</th>">>$html
echo "<th>Login Day</th>">>$html
echo "<th>Login Date</th>">>$html
echo "<th>Login Time</th>">>$html
echo "<th>Login Status</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$current_loggedin_user_name</pre></td>">>$html
echo "<td><pre>$current_loggedin_user_day</pre></td>">>$html
echo "<td><pre>$current_loggedin_user_date</pre></td>">>$html
echo "<td><pre>$current_loggedin_user_time</pre></td>">>$html
echo "<td><pre>$current_loggedin_user_status</pre></td>">>$html
echo "</tr>">>$html
echo "<tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#--------------------------------------------------------------
echo "<br>">>$html
echo "<h2><u>3.Currently Plugin Devices</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Device Name</th>">>$html
echo "<th>Device Size</th>">>$html
echo "<th>Device Type</th>">>$html
echo "<th>Device Mount Point</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$plugin_device_name</pre></td>">>$html
echo "<td><pre>$plugin_device_size</pre></td>">>$html
echo "<td><pre>$plugin_device_type</pre></td>">>$html
echo "<td><pre>$plugin_device_mountpoint</pre></td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#-------------------------------------------------------------
echo "<br>">>$html
echo "<h2><u>4.Overall Disk Usage</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Disk File System</th>">>$html
echo "<th>Disk Blocks</th>">>$html
echo "<th>Disk Used</th>">>$html
echo "<th>Disk Available</th>">>$html
echo "<th>Disk Mounted On</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$disk_name</pre></td>">>$html
echo "<td><pre>$disk_blocks</pre></td>">>$html
echo "<td><pre>$disk_in_Used</pre></td>">>$html
echo "<td><pre>$disk_available</pre></td>">>$html
echo "<td><pre>$disk_mounted_on</pre></td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#--------------------------------------------------------------
echo "<br>">>$html
echo "<h3><u>4.1.Home Directory Disk Usage</u></h3>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Home Directory Size</th>">>$html
echo "<th>Path</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$home_directory_size</pre></td>">>$html
echo "<td><pre>$home_directory_location</td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#--------------------------------------------------------------
echo "<br>">>$html
echo "<h3><u>4.2.Downloads(other) Directory Disk Usage</u></h3>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Other Directory Size</th>">>$html
echo "<th>Path</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$other_directory_size</pre></td>">>$html
echo "<td><pre>$other_directory_location</pre></td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#---------------------------------------------------------
echo "<br>">>$html
echo "<h2><u>5.Network Interfaces</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<tfoot>">>$html
echo "<tr>">>$html
echo "</td>">>$html
echo "</tr>">>$html
echo "</tfoot>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td><pre>$network_interfaces_status</pre></td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "<br>">>$html
echo "<hr>">>$html
#--------------------------------------------------------
echo "<br>">>$html
echo "<h2><u>6.Ram Usage</u></h2>">>$html
echo "<br>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>RAM in Use (In MB)</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tr>">>$html
echo "<td><pre>$current_ram_usage</pre></td>">>$html
echo "</tr>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Available RAM(In MB)</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tr>">>$html
echo "<td><pre>$ram_available</pre></td>">>$html
echo "</tr>">>$html
echo "<table class=\"blueTable\">">>$html
echo "<thead>">>$html
echo "<tr>">>$html
echo "<th>Total RAM (In MB)</th>">>$html
echo "</tr>">>$html
echo "</thead>">>$html
echo "<tbody>">>$html
echo "<tr>">>$html
echo "<td>$total_ram</td>">>$html
echo "</tr>">>$html
echo "</tbody>">>$html
echo "</table>">>$html
echo "</td>" >> $html
echo "<br>" >>$html
echo "<hr>" >>$html
echo "<br>">>$html
echo "<h2><u>Ram Usage Visual</u></h2>">>$html
echo "<br>">>$html
#---------------------------------------------------------
echo "<div id=\"piechart_3d\" style=\"width: auto; height: 200px;\"></div>" >>$html

echo "</div>" >>$html 

echo "</div>" >>$html
echo "</td>" >> $html
echo "</tr>" >> $html
echo "</table>" >> $html

echo "</body>" >>$html
echo "</html>" >>$html

firefox $html

#sending processes to log file

while true;
do
#Current Proccess
echo "$(ps aux | sort -rk 6,6 | head -n 20)" > $log
sleep 5
done
 
