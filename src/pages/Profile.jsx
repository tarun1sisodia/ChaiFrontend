import React from 'react';
import { useAuth } from '../context/AuthContext';
import Button from '../components/Button';

const Profile = () => {
    const { user, logout } = useAuth();

    if (!user) {
        return (
            <div className="flex items-center justify-center min-h-[50vh]">
                <p className="text-gray-400">Please login to view your profile.</p>
            </div>
        );
    }

    return (
        <div className="max-w-4xl mx-auto">
            {/* Cover Image */}
            <div className="relative h-48 md:h-64 rounded-xl overflow-hidden mb-8">
                <img
                    src={user.coverImage}
                    alt="Cover"
                    className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
            </div>

            {/* Profile Info */}
            <div className="relative px-4 sm:px-8 -mt-20 mb-8">
                <div className="flex flex-col sm:flex-row items-end sm:items-center space-y-4 sm:space-y-0 sm:space-x-6">
                    <div className="relative">
                        <img
                            src={user.avatar}
                            alt={user.fullName}
                            className="w-32 h-32 rounded-full border-4 border-gray-950 object-cover shadow-xl"
                        />
                    </div>
                    <div className="flex-1 pb-2">
                        <h1 className="text-3xl font-bold text-white">{user.fullName}</h1>
                        <p className="text-gray-400">@{user.username}</p>
                        <p className="text-gray-400 mt-1">{user.email}</p>
                    </div>
                    <div className="pb-2">
                        <Button variant="outline" onClick={logout}>
                            Logout
                        </Button>
                    </div>
                </div>
            </div>

            {/* Stats or other info could go here */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 px-4 sm:px-8">
                <div className="bg-gray-900 p-6 rounded-xl border border-gray-800">
                    <h3 className="text-lg font-semibold mb-2 text-gray-300">Account Created</h3>
                    <p className="text-2xl font-bold text-purple-500">
                        {new Date(user.createdAt).toLocaleDateString()}
                    </p>
                </div>
                {/* Add more stats if available */}
            </div>
        </div>
    );
};

export default Profile;
