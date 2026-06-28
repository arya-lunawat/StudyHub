<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Course;

class CourseController extends Controller
{
    public function courseList(){
        try{
            $result = Course::with('courseType')
                ->select('id', 'name', 'thumbnail', 'lesson_num', 'price', 'type_id')
                ->orderBy('type_id')
                ->get();
            
            return response()->json([
                'code' => 200,
                'msg' => 'My course list is here',
                'data' => $result
            ], 200);
        }catch(\Throwable $throw){
            return response()->json([
                'code'=>500,
                'msg' => 'The Column does not exist.',
                'data'=> $throw->getMessage()
            ],500);
        }
    }

    public function courseDetail(Request $request){
        $id = $request->id;
        try{
            $result = Course::with('courseType')
                ->where('id','=',$id)
                ->select(
                    'id',
                    'name',
                    'user_token',
                    'description',
                    'price',
                    'lesson_num',
                    'video_length',
                    'thumbnail',
                    'video_url',
                    'down_res',  // ADD THIS LINE
                    'type_id'
                )
                ->first();
            
            return response()->json([
                'code' => 200,
                'msg' => 'My course detail is here',
                'data' => $result
            ], 200);
        }catch(\Throwable $throw){
            return response()->json([
                'code'=>500,
                'msg' => 'The Column does not exist.',
                'data'=> $throw->getMessage()
            ],500);
        }
    }

    public function searchCourses(Request $request){
        $query = $request->input('query', '');
        
        try{
            if(empty($query)){
                return response()->json([
                    'code' => 200,
                    'msg' => 'Search query is empty',
                    'data' => []
                ], 200);
            }

            $result = Course::with('courseType')
                            ->where('name', 'LIKE', "%{$query}%")
                            ->orWhere('description', 'LIKE', "%{$query}%")
                            ->select('id', 'name', 'thumbnail', 'lesson_num', 'price', 'type_id')
                            ->limit(8)
                            ->get();
            
            return response()->json([
                'code' => 200,
                'msg' => 'Search results',
                'data' => $result
            ], 200);
        }catch(\Throwable $throw){
            return response()->json([
                'code'=>500,
                'msg' => 'Search error: ' . $throw->getMessage(),
                'data'=> null
            ],500);
        }
    }
}
