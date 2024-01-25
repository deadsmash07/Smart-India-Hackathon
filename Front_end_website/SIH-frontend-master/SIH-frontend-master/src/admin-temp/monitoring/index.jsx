import { useEffect, useState } from "react"
import "./monitoring.css"
import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';
import Cookies from "js-cookie";
import { useNavigate } from "react-router-dom";
import { Button, Card, CardContent, CardHeader, Dialog, DialogContent, Typography} from "@mui/material";

function Vehicle(){
    const [loading, setLoading] = useState(true);
    const [data, setData] = useState([]);
    const navigate = useNavigate();
    useEffect(() => {
        const getData = async () => {
            await fetch("http://localhost:3001/frontend/dumpsters_shovels",{
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
            }).then((res) => {
                setData(res);
                setLoading(false);
            });
        }
        getData();
    }, []);
    return(<>{loading?<Box display="flex" justifyContent="center" alignItems="center" height="100vh"><CircularProgress /></Box>:
        <div className="reportt">
            <table className="table">
                <tr className="noline">
                    <th>Vechile Id</th>
                    <th>Type</th>
                    <th>Model</th>
                    <th>Capactity</th>
                    <th>Status</th>
                </tr>
                {
                    data.shovel.map((item)=>{
                        return(<tr>
                            <td>{item.id}</td>
                            <td>Shovel</td>
                            <td>{item.name}</td>
                            <td>{item.size}</td>
                            <td>{item.status?"Working":"Not Working"}</td>
                        </tr>)
                    })     
                }
                {
                    data.dumper.map((item)=>{
                        return(<tr>
                            <td>{item.id}</td>
                            <td>Dumper</td>
                            <td>{item.name}</td>
                            <td>{item.capacity}</td>
                            <td>{item.status?"Working":"Not Working"}</td>
                        </tr>)
                    })     
                }
                <tr className="noline"></tr>
                <tr className="noline"></tr>
            </table>
        </div>}
    </>)
}
function Live(){
    const [loading, setLoading] = useState(true);
    const [data, setData] = useState([]);
    const navigate = useNavigate();
    const [anchorEl, setAnchorEl] = useState(null);

    const handleClick = (event) => {
        event.stopPropagation();
    setAnchorEl(event.currentTarget);
    };

    const handleClose = (event) => {
        event.stopPropagation();
    setAnchorEl(null);
    };

    const open = Boolean(anchorEl);
    const id = open ? 'simple-popover' : undefined;
    useEffect(() => {
        const getData = async () => {
            await fetch("http://localhost:3001/frontend/users",{
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
            }).then((res) => {
                setData(res);
                setLoading(false);
            });
        }
        getData();
    }, []);
    return(<>
        {loading?<Box display="flex" justifyContent="center" alignItems="center" height="100vh"><CircularProgress /></Box>:
        <div className="reportt">
            <table className="table">
                <tr className="noline">
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Operator</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Trips</th>
                    <th></th>
                </tr>
                {
                    data.users.map((item)=>{
                        return(<tr>
                            <td>{item._id}</td>
                            <td>{item.name}</td>
                            <td>{item.type}</td>
                            <td>{"Update this"}</td>
                            <td>{item.status?"Working":"Not Working"}</td>
                            <td>{item.total}</td>
                            <td><div onClick={handleClick}>View Profie</div>
                            <Dialog open={open} onClose={handleClose}>
                            <Card>
                                <CardHeader 
                                    title="Profile Details" 
                                    titleTypographyProps={{ variant:'h2', sx:{ fontSize: '2.5rem', color: 'orange' }}}
                                />
                                <CardContent>
                                    <Typography 
                                        variant="h6" 
                                        component="div" 
                                        sx={{ fontSize: '1.8rem'}}
                                    >
                                        Name: {item.name}
                                    </Typography>
                                    <Typography 
                                        variant="body1" 
                                        component="div" 
                                        sx={{ fontSize: '1.5rem'}}
                                    >
                                        Type: {item.type}
                                    </Typography>
                                    <Typography 
                                        variant="body1" 
                                        component="div" 
                                        sx={{ fontSize: '1.5rem' }}
                                    >
                                        ID: {item._id}
                                    </Typography>
                                    <Typography 
                                        variant="body1" 
                                        component="div" 
                                        sx={{ fontSize: '1.5rem' }}
                                    >
                                        Total: {item.total}
                                    </Typography>
                                    <Typography 
                                        variant="body1" 
                                        component="div" 
                                        sx={{ fontSize: '1.5rem' }}
                                    >
                                        History Size: {item.History.length}
                                    </Typography>
                                </CardContent>
                                <Button onClick={handleClose}>Close</Button>
                            </Card>
                            </Dialog>
                            </td>
                        </tr>)
                    })
                }
                
                <tr className="noline"></tr>
                <tr className="noline"></tr>
            </table>
        </div>}
    </>)
}
function History(){
    const [loading, setLoading] = useState(true);
    const [data, setData] = useState([]);
    const navigate = useNavigate();
    useEffect(() => {
        const getData = async () => {
            await fetch("http://localhost:3001/frontend/users",{
                headers:{
                    Authorization: `Bearer ${Cookies.get('autho')}`
                }
            }
            ).then(res => {
                if(res.status === 200){
                    return res.json();
                }
                else if(res.status===403){
                  navigate('/signin')
                }
                else{
                    console.log(res.err);
                }
            }).then((res) => {
                setData(res);
                setLoading(false);
            });
        }
        getData();
    }, []);
    return (<>
        {loading?<Box display="flex" justifyContent="center" alignItems="center" height="100vh"><CircularProgress /></Box>:
        <div className="reportt">
            <table className="table">
                <tr className="noline">
                    <th>Name</th>
                    <th>Operator</th>
                    <th>Km travelled</th>
                </tr>
                <tr>
                    <td>Pratyaksh</td>
                    <td>Dumper</td>
                    <td>100</td>
                </tr>
                {data.users.map((item)=>{
                        return(<tr>
                            <td>{item.name}</td>
                            <td>{item.type}</td>
                            <td>{item.total}</td>
                        </tr>)
                    })
                }

                <tr className="noline">
                    <td>Shivam</td>
                    <td>Shovel</td>
                    <td>50</td>
                </tr>
                <tr className="noline"></tr>
                <tr className="noline"></tr>
            </table>
        </div>}
    </>)
}
export default function Monitoring(){
    const [state,setState]=useState(0)
    return(<>
        <div className="content">
        <div className="nav">
            <div className="navheading">
                <div className={`vecstatus ${state === 0 ? 'active' : ''}`} onClick={()=>{setState(0)}}>Vehicle Status</div>
                <div className={`livedata ${state === 1 ? 'active' : ''}`} onClick={()=>{setState(1)}}>Live data</div>
                <div className={`history ${state === 2 ? 'active' : ''}`} onClick={()=>{setState(2)}}>history</div>
            </div>
    
            <div className="filter">
                <span className="material-symbols-outlined">
                    Filter_Alt
                </span>
                <div>Filter</div>
            </div>
        </div>
        {
            state === 0 ? <Vehicle/> : state === 1 ? <Live/> : <History/>
        }
    </div>
    </>)
}