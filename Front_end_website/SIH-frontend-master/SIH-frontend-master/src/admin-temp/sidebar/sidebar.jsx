import { Link, useLocation, useNavigate } from "react-router-dom";
import "./stylebar.css"
import Cookies from "js-cookie";
export default function Sidebar() {
  const location=useLocation();
  const navigate = useNavigate();
  return (
    <>
      <div className="sidebar">
        <div className="brand-name">Elevate</div>
        <div className="line"></div>
        <div className="heading">
            <Link className={`heading-name ${location.pathname === "/" ? "active" : ""}`} to="/">
                <span className="material-symbols-outlined">home</span>
                Dashboard
            </Link>
            <Link className={`heading-name ${location.pathname === "/vehiclestatus" ? "active" : ""}`} to="/vehiclestatus">
                <span className="material-symbols-outlined">person</span>
                Monitoring
            </Link>
            <Link className={`heading-name ${location.pathname === "/announcement" ? "active" : ""}`} to="/announcement">
                <span className="material-symbols-outlined">campaign</span>
                Announcement
            </Link>
            <Link className={`heading-name ${location.pathname === "/message" ? "active" : ""}`} to="/message">
                <span className="material-symbols-outlined">chat_bubble</span>
                Message
            </Link>
        </div>
        <div className="line"></div>
        <div className="user">
            <div className="user-photo"></div>
            <div className="user-data">
                <div className="user-name">{Cookies.get('name')}</div>
                <div className="user-code">2022CS51654</div>
            </div>
        </div>
        <div className="logout" onClick={()=>{
                Cookies.remove('autho');
                Cookies.remove('name')
                navigate('/signin', { replace: true });
            }}>
            <span className="material-symbols-outlined" >logout</span>
            Logout
        </div>
    </div>
    </>
  );
}
