<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Doubt;
use App\Models\DoubtReply;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;

class DoubtController extends Controller
{
    /**
     * Get all doubts for a course with their replies
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request)
    {
        try {
            $courseId = $request->query('course_id');

            if (!$courseId) {
                return response()->json([
                    'code' => 400,
                    'msg' => 'course_id is required',
                    'data' => []
                ], 400);
            }

            // Get all doubts with their replies, ordered by latest first
            $doubts = Doubt::where('course_id', $courseId)
                ->with(['replies' => function ($query) {
                    $query->orderBy('created_at', 'asc');
                }])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'code' => 200,
                'msg' => 'Doubts fetched successfully',
                'data' => $doubts
            ], 200);

        } catch (\Throwable $th) {
            return response()->json([
                'code' => 500,
                'msg' => 'Error fetching doubts',
                'error' => $th->getMessage()
            ], 500);
        }
    }

    /**
     * Store a new doubt
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validate input
            $validateDoubt = Validator::make($request->all(), [
                'course_id' => 'required|integer',
                'user_token' => 'required|string',
                'user_name' => 'required|string',
                'doubt_text' => 'required|string|min:3'
            ]);

            if ($validateDoubt->fails()) {
                return response()->json([
                    'code' => 422,
                    'msg' => 'Validation error',
                    'errors' => $validateDoubt->errors()
                ], 422);
            }

            $validated = $validateDoubt->validated();
            $validated['created_at'] = Carbon::now();
            $validated['updated_at'] = Carbon::now();

            // Insert and get the ID
            $doubtId = Doubt::insertGetId($validated);

            // Get the created doubt with empty replies
            $doubt = Doubt::with('replies')
                ->where('id', $doubtId)
                ->first();

            return response()->json([
                'code' => 201,
                'msg' => 'Doubt posted successfully',
                'data' => $doubt
            ], 201);

        } catch (\Throwable $th) {
            return response()->json([
                'code' => 500,
                'msg' => 'Error posting doubt',
                'error' => $th->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a doubt (only by the doubt creator or admin)
     * @param Request $request
     * @param int $id
     * @return JsonResponse
     */
    public function destroy(Request $request, $id)
    {
        try {
            $userToken = $request->query('user_token');

            $doubt = Doubt::find($id);

            if (!$doubt) {
                return response()->json([
                    'code' => 404,
                    'msg' => 'Doubt not found'
                ], 404);
            }

            // Only allow deletion by the doubt creator
            if ($doubt->user_token !== $userToken) {
                return response()->json([
                    'code' => 403,
                    'msg' => 'Unauthorized - you can only delete your own doubts'
                ], 403);
            }

            $doubt->delete();

            return response()->json([
                'code' => 200,
                'msg' => 'Doubt deleted successfully'
            ], 200);

        } catch (\Throwable $th) {
            return response()->json([
                'code' => 500,
                'msg' => 'Error deleting doubt',
                'error' => $th->getMessage()
            ], 500);
        }
    }
}
