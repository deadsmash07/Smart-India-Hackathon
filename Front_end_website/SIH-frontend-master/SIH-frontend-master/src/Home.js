import { Routes, Route } from "react-router-dom";
// import Landing from "./templates/landing.js";
import Sidebar from "./admin-temp/sidebar/sidebar.jsx";
import Dashboard from "./admin-temp/dashboard/index.jsx";
import Monitoring from "./admin-temp/monitoring/index.jsx";
import Announcement from "./admin-temp/announcement/index.jsx";
import Message from "./admin-temp/message/index.jsx";




export default function Home(){
    return(
        <div>
            <Sidebar />
            <Routes>
                <Route path="/" element={<Dashboard/>} />
                <Route path="/vehiclestatus" element={<Monitoring/>} />
                <Route path="/announcement" element={<Announcement/>} />
                <Route path="/message" element={<Message/>} />
                <Route path="*" element={<Dashboard/>} />
            </Routes>

        </div>
    );
}