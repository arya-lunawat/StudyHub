<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DoubtController;
use App\Http\Controllers\Api\DoubtReplyController;

Route::group(['namespace'=>'Api'], function(){

    Route::post('/login', 'UserController@createUser');
    
    // Doubt Routes - NO AUTHENTICATION (for testing)
    Route::get('/doubts', [DoubtController::class, 'index']);
    Route::post('/doubts', [DoubtController::class, 'store']);
    Route::delete('/doubts/{id}', [DoubtController::class, 'destroy']);

    // Doubt Reply Routes - NO AUTHENTICATION (for testing)
    Route::post('/doubt-replies', [DoubtReplyController::class, 'store']);
    Route::delete('/doubt-replies/{id}', [DoubtReplyController::class, 'destroy']);
    
    Route::group(['middleware'=>['auth:sanctum']], function(){
        Route::any('/courseList', 'CourseController@courseList');
        Route::any('/courseDetail', 'CourseController@courseDetail');
        Route::any('/checkout', 'PayController@checkout');
        Route::any('/searchCourses', 'CourseController@searchCourses');
        // Comment routes for courses
        Route::get('/courses/{id}/comments', [CommentController::class, 'getComments']);
        Route::post('/courses/{id}/comments', [CommentController::class, 'storeComment']);
        
        // NEW: Video streaming from your uploads/files folder
        Route::get('/videos/{filename}', function ($filename) {
            $path = storage_path('app/public/uploads/files/' . $filename);
            
            if (strpos(realpath($path), realpath(storage_path('app/public/uploads/files'))) !== 0) {
                abort(403, 'Unauthorized access');
            }
            
            if (!file_exists($path)) {
                abort(404, 'Video not found');
            }
            
            return response()->file($path, [
                'Content-Type' => 'video/mp4',
                'Accept-Ranges' => 'bytes',
                'Cache-Control' => 'public, max-age=86400',
            ]);
        })->name('video.stream');
    });

});
