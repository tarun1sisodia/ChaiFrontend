import React from 'react';

const Button = ({ children, type = 'button', variant = 'primary', className = '', ...props }) => {
    const baseStyles = "px-4 py-2 rounded-lg font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed";

    const variants = {
        primary: "bg-purple-600 hover:bg-purple-700 text-white focus:ring-purple-500",
        secondary: "bg-gray-800 hover:bg-gray-700 text-white focus:ring-gray-500",
        outline: "border-2 border-purple-600 text-purple-400 hover:bg-purple-600/10 focus:ring-purple-500",
        ghost: "text-gray-400 hover:text-white hover:bg-white/10 focus:ring-gray-500",
        danger: "bg-red-600 hover:bg-red-700 text-white focus:ring-red-500",
    };

    return (
        <button
            type={type}
            className={`${baseStyles} ${variants[variant]} ${className}`}
            {...props}
        >
            {children}
        </button>
    );
};

export default Button;
