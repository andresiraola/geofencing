<%@page import="fr.utbm.set.domain.TypeVehicle"%>
<%@page import="fr.utbm.set.domain.Geofence"%>
<%@page import="java.util.List"%>
<%@page import="fr.utbm.dao.ConnexionProperties"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="fr.utbm.set.util.Database"%>
<%@page import="fr.utbm.dao.GeofenceDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>
                Geofencing Application
            </title>
            <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAGEyWe3q--H87glW56a7QehQsvEaGTJq5ceZjW4jiQAGPwgeiaxR9bDMEhgIxCOmEdaWBT9ghhEJMYQ"
            type="text/javascript"></script>
            <script src="javascript/googlemaps.js" type="text/javascript"></script>
            <script src="javascript/jquery-1.4.4.min.js" type="text/javascript"></script>
            <script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.core.js"></script>
            <script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.widget.js"></script>
            <script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.mouse.js"></script>
            <script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.draggable.js"></script>

            <script type="text/javascript" src="javascript/jquery.utils.js"></script>
            <script type="text/javascript" src="javascript/jquery.strings.js"></script>
            <script type="text/javascript" src="javascript/jquery.anchorHandler.js"></script>
            <script type="text/javascript" src="javascript/jquery.ui.all.js"></script>
            <script type="text/javascript" src="javascript/ui.timepickr.js"></script>
            <script type="text/javascript" src="jquery.ui.datepicker.js"></script>
            <script type="text/javascript" src="jquery.ui.datepicker-en-GB"></script>

            <script type="text/javascript" src="javascript/function.js"></script>
            
            <link rel="stylesheet" type="text/css" href="css/base.css" media="all" />
            <link rel="stylesheet" type="text/css" href="css/design_2.css" media="screen" />
            <link rel="Stylesheet" media="screen" href="css/ui.core.css" />
            <link rel="stylesheet" media="screen" href="css/ui.timepickr.css" type="text/css" />
            <link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.6.custom.css" />

            <script type="text/javascript">

            </script>
        </head>
        <body onload="load();" onunload="GUnload();">
            <div id="global">
                <div id="entete">
                    <h1>
                        <img alt="Logo" src="Images/earth.png" />
                        <span>Geofences</span>
                    </h1>
                    <p class="sous-titre">
                        <%
                            java.util.Date date = new java.util.Date();
                            java.text.SimpleDateFormat  simpleFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
                        %>
                        <%= simpleFormat.format(date)%>
                    </p>
                </div><!-- header -->
                <div id="navigation">
                    <ul>
                        <li class="gauche"><a href="index.jsp">Home</a></li>
                        <li class="gauche"><a >Geofences</a></li>
                        <li class="droite"><a >Settings</a></li>
                        <li class="droite"><a >Account</a></li>
                        <li class="droite"><a >Help</a></li>
                    </ul>
                </div><!-- navigation -->
                <div id="centre">
                    <div id="principal">
                            <div id="map">

                            </div>
                            <div id="toolBox">
                                <ul>
                                    <li class="gauche"><img id="imgCursorMode" alt="Cursor Mode"  src="Images/cursor.png" onclick="setAction('cursor')" class="btnToolBox" title="Cursor Mode"></li>
                                    <li class="gauche"><img id="imgAddMode" alt="Add Mode"  src="Images/add.png" onclick="setAction('add'); " class="btnToolBox" title="Add Mode"></li>
                                    <li class="gauche"><img id="imgEditMode" alt="Edit Mode"  src="Images/edit.png" onclick="setAction('edit')" class="btnToolBox" title="Edit Mode"></li>
                                    <li class="gauche"><img id="imgDeleteMode" alt="Delete Mode"  src="Images/delete.png" onclick="setAction('remove')" class="btnToolBox" title="Delete Mode"></li>
                                    <!--<li class="gauche"><img id="imgValidate" alt="Validate"  src="Images/validate.png" onclick="setValidateMode(); validate()" class="btnToolBox" title="Validate"></li>-->
                                    <li class="gauche"><label for="ckPoly">Drawning Full :</label></li>
                                    <li class="gauche"><input type="checkbox" id="ckPoly" onclick="setTypePoly()" class="btnToolBox"></li>
                                    <li class="gauche"><label for="ckPolySuperimpose">Superimpose :</label></li>
                                    <li class="gauche"><input type="checkbox" id="ckPolySuperimpose" onclick="setSuperimpose()" class="btnToolBox"></li>
                                    <!--<li class="droite"><img id="imgDeleteSchedule" alt="Delete Schedule"  src="Images/clock_delete.png" onclick="validate()" class="btnToolBox" title="Delete Schedule"></li>
                                    <li class="droite"><img id="imgEditSchedule" alt="Edit Schedule"  src="Images/clock_edit.png" onclick="validate()" class="btnToolBox" title="Edit Schedule"></li>-->
                                    <li class="droite"><img id="imgAddSchedule" alt="Add Schedule"  src="Images/clock_add.png" onclick="displayDiv('divAddHour')" class="btnToolBox" title="Add Schedule"></li>
                                </ul>
                            </div>

                    </div><!-- principal -->
                    <div id="secondaire">
                        <h3>Geofence characteristics</h3>
                        <div class="formBoxContent">
                            <form action="/GeofencingClient/addGeofence" method="post">


                                        <label for="txtGeofenceTitle">Title :</label>
                                        <input id="txtGeofenceTitle" name="txtGeofenceTitle" type="text">


                                        <label for="selectedColor">Color :</label>
                                        <select id="selectedColor" name="selectedColor" onChange="drawPoly(typePoly);">
                                            <option value="FF0000">Red</option>
                                            <option value="009900">Green</option>
                                            <option value="FFFF00">Yellow</option>
                                            <option value="C0C0C0">Gray</option>
                                            <option value="000000">Black</option>
                                            <option value="993399">Purple</option>
                                            <option value="000CFF">Blue</option>
                                            <option value="FF000F">Dark red</option>
                                        </select>



                                        <label for="txtSpeedLimit">Speed limit :</label>
                                        <input id="txtSpeedLimit" name="txtSpeedLimit" type="text">


                                        <label for="txtMaxWeight">Max weight :</label>
                                        <input id="txtMaxWeight" name="txtMaxWeight" type="text">


                                        <label for="txtMaxHeight">Max height :</label>
                                        <input id="txtMaxHeight" name="txtMaxHeight" type="text">


                                        <label for="selectedVehiclesProhibited">Vehicles prohibited :</label>
                                        <select id="selectedVehiclesProhibited" name="selectedVehiclesProhibited" multiple="true">
                                            <option value="1">Car</option>
                                            <option value="2">Truck</option>
                                            <option value="3">Two wheels</option>
                                        </select>

                                        <div>
                                            <label for="chkIsTDG" class="inline">Transportation of dangerous goods :</label>
                                            <input id="chkIsTDG" name="chkIsTDG" type="checkbox">
                                        </div>
                            </form>
                        </div>
                        <div class="formBoxActions">
                            <input type="button" id="btnSave" value="Save" onclick="saveGeofence()">
                            <input type="button" value="Cancel" onClick="cancelGeofence()">
                            <input type="button" value="Delete" onClick="deleteGeofence()">
                        </div>
                        <div id="geofenceList">
                            <label for="selectedGeofence">Geofence :</label>
                            <select id="selectedGeofence" name="selectedGeofence" onChange="testShowGeofence()">
                                <option value="-1"></option>
                                <%
                                Database dtb = new Database(Database.MYSQL);
                                dtb.openDatabase(ConnexionProperties.DB_URL, ConnexionProperties.DB_USR, ConnexionProperties.DB_PWD);
                               // List<Geofence> listGeo = new List<Geofence>();
                                if(dtb != null){
                                    System.out.println("dtb ok");
                                    Connection db = dtb.getConnection();
                                    if(db != null){
                                        System.out.println("connection ok");
                                        Statement isql = db.createStatement();
                                        if(isql != null){
                                            System.out.println("statement created");
                                            ResultSet rs = isql.executeQuery("select * from geofence");
                                            if(rs != null){
                                                 while(rs.next()){
                                                    %><option value="<%=rs.getLong("geofenceID")%>"><%=rs.getString("geofenceName")%></option><%
                                                    //new Geofence(rs.getString("geofenceName"),new List<TypeVehicle>(),rs.getFloat("speedLimit"),rs.getDouble("weight"),rs.getDouble("height"),new List<Point>(),rs.getBoolean("isTDG"));
                                                    //listGeo.add();
                                               }
                                            }
                                            else
                                                System.out.println("error reading resultset");
                                        }
                                        else
                                            System.out.println("no statement created");
                                    }
                                    else
                                        System.out.println("no connection");
                                }
                                else
                                    System.out.println("database ok");
                                %>
                            </select>
                        </div>
                    </div><!-- secondary -->
                </div><!-- centre -->
                <div id ="divSeeHours">
                    <p id="pHours">

                    </p>
                    <p id="copyright">
                        Copyright &copy; GSEM 2010. Tous droits résérvés.
                    </p>
                </div>
                <div id="divAddHour">
                    <div id="moveBar">
                        Add Schedule
                        <img alt="Close"  src="Images/close_bt.png" onclick="pushClose()" class="btnToolBox" title="Close">
                    </div>
                    <div id="divdatepicker">
                        <img id="imgDate" alt="Day"  src="Images/day.png" onclick="setDate()" class="datePicker" title="A whole day">
                        <img id="imgWeek" alt="Date to Date"  src="Images/calendar.png" onclick="setDateToDate()" class="datePicker" title="Date to date">
                        <img id="imgDatetime" alt="Date and Time"  src="Images/datetime.png" onclick="setDateTime()" class="datePicker" title="Date and begin/end hours">
                        <img id="imgDaysAndHoursInWeek" alt="Date and begin/end hours"  src="Images/date.png" onclick="setDaysAndHoursInWeek()" class="datePicker" title="Days in a week">
                        <img id="imgAlways" alt="Always"  src="Images/infinity.png" onclick="saveSchedule('0')" class="datePicker" title="Always">
                    </div>
                    <div id="divDate">
                        <form action="" method="post">
                            <label for="datepickeroneDay">Pick a Day</label>
                            <input type="text" name="oneDay" id="datepickeroneDay">
                        </form>
                        <input type="button" value="Save" onclick="saveSchedule('1')">
                    </div>
                    <div id="divDateToDate">
                        <form action="" method="post">
                            <div id="addDTDLeft">
                                <label for="datepickerDTDBeginDay">Begin Day</label>
                                <input type="text" name="oneDay" id="datepickerDTDBeginDay">
                                <label for="datepickerDTDEndDay">End Day</label>
                                <input type="text" name="oneDay" id="datepickerDTDEndDay">
                            </div>
                            <div id="addDTDRight">
                                <label for="txtDTDBeginHour">Begin Time:</label>
                                <input id="txtDTDBeginHour" type="text">
                                <label for="txtDTDEndHour"  class="topEightyPX">End Time:</label>
                                <input id="txtDTDEndHour" type="text">
                            </div>
                        </form>
                        <input id="btnDTDSaveHour" type="button" value="Save" onclick="saveSchedule('2')">
                    </div>
                    <div id="divDatetime">
                        <form action="" method="post">
                            <div id="addDTLeft">
                                <label for="datepickerDTDay">Day</label>
                                <input type="text" name="oneDay" id="datepickerDTDay">
                            </div>
                            <div id="addDTRight">
                                <label for="txtDTBeginHour">Begin Time:</label>
                                <input id="txtDTBeginHour" type="text">
                                <label for="txtDTEndHour"  class="topEightyPX">End Time:</label>
                                <input id="txtDTEndHour" type="text">
                            </div>
                        </form>
                        <input id="btnDTSaveHour" type="button" value="Save" onclick="saveSchedule('3')">
                    </div>
                    <div id="divDaysAndHoursInWeek">
                        <form action="" method="post">
                            <div id="addScheduleLeft">
                                Week Days:
                                <div>
                                    <input id="chkMon" name="chkMon" type="checkbox">
                                    <label for="chkMon" class="inline">Mon.</label>
                                </div>
                                <div>
                                    <input id="chkTue" name="chkTue" type="checkbox">
                                    <label for="chkTue" class="inline">Tue.</label>
                                </div>
                                <div>
                                    <input id="chkWed" name="chkWed" type="checkbox">
                                    <label for="chkWed" class="inline">Wed.</label>
                                </div>
                                <div>
                                    <input id="chkThu" name="chkThu" type="checkbox">
                                    <label for="chkThu" class="inline">Thu.</label>
                                </div>
                                <div>
                                    <input id="chkFri" name="chkFri" type="checkbox">
                                    <label for="chkFri" class="inline">Fri.</label>
                                </div>
                                <div>
                                    <input id="chkSat" name="chkSat" type="checkbox">
                                    <label for="chkSat" class="inline">Sat.</label>
                                </div>
                                <div>
                                    <input id="chkSun" name="chkSun" type="checkbox">
                                    <label for="chkSun" class="inline">Sun.</label>
                                </div>
                            </div>
                            <div id="addScheduleRight">
                                <label for="txtBeginning">Begin Time:</label>
                                <input id="txtBeginning" type="text" value="09:00">
                                <label for="txtEnd"  class="topEightyPX">End Time:</label>
                                <input id="txtEnd" type="text" value="09:00">
                            </div>
                        </form>
                        <input id="saveDayHour" type="button" value="Save" onclick="saveSchedule('4')">
                    </div>
                </div>
            </div><!-- global -->
            <script src="javascript/draggable.js" type="text/javascript"></script>
            <p id="listeLat"></p>
            <p id="listeLng"></p>
            <p id="listePoints"></p>
            <p id="pcursor"></p>
        </body>
    </html>
