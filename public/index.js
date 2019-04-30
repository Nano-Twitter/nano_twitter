
import ReactDOM from 'react-dom';
import Navbar from "./components/Navbar";
import React from 'react';
import * as serviceWorker from './serviceWorker';
import { Provider } from 'mobx-react';
import rootStore from './stores/rootStore'
import Home from './containers/Home';
import Login from './containers/Login';
import Register from './containers/Register';
import AuthorizedRoute from './components/authorizationRequiredRoute';
import JumpToHomeIfLogedInRoute from './components/JumpToHomeIfLogedInRoute';
import { BrowserRouter, Switch, Route } from "react-router-dom";
ReactDOM.render(
    <Provider rootStore={rootStore}>
        <Navbar />
    </Provider>
    , document.getElementById('navbar')
);
ReactDOM.render(
    <Provider rootStore={rootStore}>
        <BrowserRouter>
            <div>
                <Switch>
                    <AuthorizedRoute exact path="/" component={Home} />
                    <JumpToHomeIfLogedInRoute path="/login" component={Login} />
                    <Route path="/register" component={Register} />
                    <AuthorizedRoute path="/home" component={Home} />
                    <Route path="/search/:term" component={Search}/>
                </Switch>
            </div>
        </BrowserRouter>
    </Provider>
    ,
    document.getElementById("body")
);

serviceWorker.register();


