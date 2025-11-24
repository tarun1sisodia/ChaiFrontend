import React from 'react';
import { useForm } from 'react-hook-form';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import Input from '../components/Input';
import Button from '../components/Button';

const Register = () => {
    const { register, handleSubmit, formState: { errors } } = useForm();
    const { register: registerUser } = useAuth();
    const navigate = useNavigate();
    const [error, setError] = React.useState('');
    const [loading, setLoading] = React.useState(false);

    const onSubmit = async (data) => {
        setError('');
        setLoading(true);
        try {
            await registerUser(data);
            navigate('/login'); // Redirect to login after registration
        } catch (err) {
            setError(err.response?.data?.message || 'Registration failed');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="flex items-center justify-center min-h-[80vh] py-12">
            <div className="w-full max-w-md bg-gray-900 p-8 rounded-xl border border-gray-800 shadow-2xl">
                <h2 className="text-3xl font-bold text-center mb-6 text-white">Sign Up</h2>

                {error && (
                    <div className="bg-red-500/10 border border-red-500 text-red-500 px-4 py-2 rounded-lg mb-6 text-sm">
                        {error}
                    </div>
                )}

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                    <Input
                        label="Full Name"
                        {...register('fullName', { required: 'Full name is required' })}
                        error={errors.fullName?.message}
                        placeholder="Enter your full name"
                    />

                    <Input
                        label="Email"
                        type="email"
                        {...register('email', {
                            required: 'Email is required',
                            pattern: {
                                value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                                message: "Invalid email address"
                            }
                        })}
                        error={errors.email?.message}
                        placeholder="Enter your email"
                    />

                    <Input
                        label="Username"
                        {...register('username', { required: 'Username is required' })}
                        error={errors.username?.message}
                        placeholder="Choose a username"
                    />

                    <Input
                        label="Password"
                        type="password"
                        {...register('password', {
                            required: 'Password is required',
                            minLength: {
                                value: 6,
                                message: "Password must be at least 6 characters"
                            }
                        })}
                        error={errors.password?.message}
                        placeholder="Create a password"
                    />

                    <div className="space-y-2">
                        <label className="block text-sm font-medium text-gray-300">Avatar</label>
                        <input
                            type="file"
                            accept="image/*"
                            {...register('avatar', { required: 'Avatar is required' })}
                            className="block w-full text-sm text-gray-400
                file:mr-4 file:py-2 file:px-4
                file:rounded-full file:border-0
                file:text-sm file:font-semibold
                file:bg-purple-600 file:text-white
                hover:file:bg-purple-700
              "
                        />
                        {errors.avatar && <p className="text-sm text-red-500">{errors.avatar.message}</p>}
                    </div>

                    <div className="space-y-2">
                        <label className="block text-sm font-medium text-gray-300">Cover Image</label>
                        <input
                            type="file"
                            accept="image/*"
                            {...register('coverImage')}
                            className="block w-full text-sm text-gray-400
                file:mr-4 file:py-2 file:px-4
                file:rounded-full file:border-0
                file:text-sm file:font-semibold
                file:bg-gray-700 file:text-white
                hover:file:bg-gray-600
              "
                        />
                    </div>

                    <Button
                        type="submit"
                        variant="primary"
                        className="w-full py-3"
                        disabled={loading}
                    >
                        {loading ? 'Creating Account...' : 'Sign Up'}
                    </Button>
                </form>

                <p className="mt-6 text-center text-gray-400">
                    Already have an account?{' '}
                    <Link to="/login" className="text-purple-500 hover:text-purple-400 font-medium">
                        Login
                    </Link>
                </p>
            </div>
        </div>
    );
};

export default Register;
