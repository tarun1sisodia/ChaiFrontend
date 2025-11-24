import React from 'react';
import { Link } from 'react-router-dom';
import Button from '../components/Button';

const Home = () => {
    return (
        <div className="flex flex-col items-center justify-center min-h-[80vh] text-center">
            <h1 className="text-5xl font-bold mb-6 bg-gradient-to-r from-purple-400 to-pink-600 text-transparent bg-clip-text">
                Welcome to ChaiPlay
            </h1>
            <p className="text-xl text-gray-400 mb-8 max-w-2xl">
                The premium video sharing platform for chai lovers. Upload, watch, and share your favorite moments.
            </p>
            <div className="flex space-x-4">
                <Link to="/register">
                    <Button variant="primary" className="text-lg px-8 py-3">
                        Get Started
                    </Button>
                </Link>
                <Link to="/login">
                    <Button variant="outline" className="text-lg px-8 py-3">
                        Login
                    </Button>
                </Link>
            </div>
        </div>
    );
};

export default Home;
