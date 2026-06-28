<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Encore\Admin\Auth\Database\Administrator;
use Encore\Admin\Auth\Database\Role;
use Encore\Admin\Auth\Database\Permission;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Create admin user
        $admin = Administrator::firstOrCreate([
            'username' => 'admin',
        ], [
            'password' => bcrypt('admin'),
            'name' => 'Administrator',
        ]);

        // Create a role
        $role = Role::firstOrCreate([
            'name' => 'Administrator',
            'slug' => 'administrator',
        ]);

        // Assign role to user
        $admin->roles()->sync([$role->id]);

        // Create permissions for courses
        $permissions = [
            [
                'name' => 'All permission',
                'slug' => '*',
                'http_method' => '',
                'http_path' => '*',
            ],
            [
                'name' => 'Dashboard',
                'slug' => 'dashboard',
                'http_method' => 'GET',
                'http_path' => '/',
            ],
            [
                'name' => 'Login',
                'slug' => 'auth.login',
                'http_method' => '',
                'http_path' => "/auth/login\r\n/auth/logout",
            ],
            [
                'name' => 'User setting',
                'slug' => 'auth.setting',
                'http_method' => 'GET,PUT',
                'http_path' => '/auth/setting',
            ],
            [
                'name' => 'Auth management',
                'slug' => 'auth.management',
                'http_method' => '',
                'http_path' => "/auth/roles\r\n/auth/permissions\r\n/auth/menu\r\n/auth/logs",
            ],
            [
                'name' => 'Course management',
                'slug' => 'courses',
                'http_method' => '',
                'http_path' => '/courses*',
            ],
        ];

        foreach ($permissions as $permissionData) {
            $permission = Permission::firstOrCreate([
                'slug' => $permissionData['slug'],
            ], $permissionData);

            // Assign permission to role
            $role->permissions()->syncWithoutDetaching([$permission->id]);
        }
    }
}
