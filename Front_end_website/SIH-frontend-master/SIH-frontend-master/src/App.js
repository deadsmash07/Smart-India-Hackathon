
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import SignIn from './SignIn/index.js';
import Home from './Home.js';
function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/signin" element={<SignIn />} />
          <Route path="*" element={<Home />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
