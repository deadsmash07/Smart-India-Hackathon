import { useEffect, useState } from "react";
import "./dashboard.css"
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';

import L from 'leaflet';
import { useNavigate } from "react-router-dom";
import Cookies from "js-cookie";
import { CircularProgress } from "@mui/material";
// Fix for default marker icon path
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

function LeafletMap() {
  const [currentLocation, setCurrentLocation] = useState(null);
  const [data,setData]=useState([])
  const navigate=useNavigate();
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    if (navigator && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(pos => {
        const { latitude, longitude } = pos.coords;

        setCurrentLocation({
          lat: latitude,
          lng: longitude
        });
      });
    }
    const location=async()=>{
      await fetch("http://localhost:3001/frontend/drivers",{
        headers:{
          'Authorization': `Bearer ${Cookies.get('autho')}`
        }
    }
    ).then(
        res => {
            if(res.status === 200){
                return res.json();
            }
            else if(res.status===403){
              navigate('/signin')
            }
            else{
                console.log(res.err);
            }
        }
    ).then(data => {
      setData(data.users)
    }).catch(err => {
        console.log(err);

    })
  }
  location();
    
  setLoading(false);
  }, []);

  return (
    <>{
      loading?<CircularProgress />:
    <div className="leaflet-map">
  {currentLocation && (
    <MapContainer
      center={[currentLocation.lat, currentLocation.lng]}
      zoom={12}
      className="map"
      style={{height:"350px", width:"700px"}}
      // scrollWheelZoom={false}
      // zoomControl={false}
      // dragging={false}
    >
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      />
      <Marker position={[currentLocation.lat, currentLocation.lng]} />
      {data.map((item)=>{
        return(<Marker position={[item.latitude,item.longitude]}/>)
      })}
    </MapContainer>
  )}
</div>}</>
  );
};

function GoogleChart() {
    useEffect(() => {
      const script = document.createElement('script');
      script.src = 'https://www.gstatic.com/charts/loader.js';
      script.onload = () => {
        window.google.charts.load('current', { packages: ['corechart'] });
        window.google.charts.setOnLoadCallback(drawChart);
      };
      document.body.appendChild(script);
  
      function drawChart() {
        var data = window.google.visualization.arrayToDataTable([
          ['Time', 'Ore', 'Overburden'],
          ['7', 1000, 400],
          ['8', 1170, 460],
          ['9', 660, 1120],
          ['10', 1030, 540],
          ['11', 900, 726],
          ['12', 910, 720]
        ]);
  
        var options = {
          title: 'Extraction',
          curveType: 'function',
          width: 340,
          height: 340,
        };
  
        var chart = new window.google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    }, []);
  
    return <div id="chart_div" />;
  }
export default function Dashboard(){
    const navigate=useNavigate();
    const [data, setData] = useState({trueDumper:"Pls wait",falseDumper:"Pls wait",trueShovel:"Pls wait",falseShovel:"Pls wait"});
    const [announcement, setAnnouncement] = useState([]);
    useEffect(() => {
        const getData = async () => {
        await fetch("http://localhost:3001/frontend/dumpers_shovels_summary",{
          headers:{
            'Authorization': `Bearer ${Cookies.get('autho')}`
          }
        }).then(res => {
                if(res.status === 200){
                    return res.json();
                }
                else if(res.status===403){
                  navigate('/signin')
                }
                else{
                    console.log(res.err);
                }
            }
            ).then(data => {
                setData(data);
            }).catch(err => {
                console.log(err);
            })
            await fetch("http://localhost:3001/frontend/annoucements",{
              headers:{
                Authorization: `Bearer ${Cookies.get('autho')}`
              }
            }).then(res => {
                if(res.status === 200){
                    return res.json();
                }
                else if(res.status===403){
                  navigate('/signin')
                }
                else{
                    console.log(res.err);
                }
            }
            ).then(data => {
                if(data.length >5)
                    data = data.slice(0,5);
                setAnnouncement(data.annoucements);
            }).catch(err => {
                console.log(err);
            })
        };
        getData();
    },[])

    return (
        <>
        <div className="content">
        <div className="top">
            {/* <div className="map"></div> */}
            <LeafletMap />
            <div className="r">
                <div className="showel">
                    <div className="headingss">Showel</div>
                    <div className="row">
                        <div>Active:</div>
                        <div>{data.trueShovel}</div>
                    </div>
                    <div className="row">
                        <div>Inactive:</div>
                        <div>{data.falseShovel}</div>
                    </div>
                </div>
                <div className="Dumper">
                    <div className="headingss">Dumper</div>
                    <div className="row">
                        <div>Active:</div>
                        <div>{data.trueDumper}</div>
                    </div>
                    <div className="row">
                        <div>Inactive:</div>
                        <div>{data.falseDumper}</div>
                    </div>
                </div>
            </div>
        </div>
        <div className="topbottom">
            <div className="report">
                <table className="table">
                    <tr className="noline">
                        <th>Alerts</th>                   
                    </tr>
                    {
                        announcement.map((item) => {
                            return (
                                <tr>
                                    <td>{new Date(item.createdAt).toLocaleString()}: {item.content}</td>
                                </tr>
                            )
                        })
                    }
                </table>
            </div>
            <div className="graph">
                <div id="curve_chart" style={{width: "340px", height: "340px"}}>
                    <GoogleChart />
                </div>
            </div>
        </div>
    </div>
        </>
    )
}