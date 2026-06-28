<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Doubt;
use App\Models\DoubtReply;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;

class DoubtReplyController extends Controller
{
    /**
     * Store a new reply to a doubt
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validate input
            $validateReply = Validator::make($request->all(), [
                'doubt_id' => 'required|integer|exists:doubts,id',
                'user_token' => 'required|string',
                'user_name' => 'required|string',
                'reply_text' => 'required|string|min:3',
                'is_teacher' => 'required|boolean'
            ]);

            if ($validateReply->fails()) {
                return response()->json([
                    'code' => 422,
                    'msg' => 'Validation error',
                    'errors' => $validateReply->errors()
                ], 422);
            }

            $validated = $validateReply->validated();
            $validated['created_at'] = Carbon::now();
            $validated['updated_at'] = Carbon::now();

            // Insert and get the ID
            $replyId = DoubtReply::insertGetId($validated);

            // Get the created reply
            $reply = DoubtReply::find($replyId);

            return response()->json([
                'code' => 201,
                'msg' => 'Reply posted successfully',
                'data' => $reply
            ], 201);

        } catch (\Throwable $th) {
            return response()->json([
                'code' => 500,
                'msg' => 'Error posting reply',
                'error' => $th->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a reply (only by reply creator or admin)
     * @param Request $request
     * @param int $id
     * @return JsonResponse
     */
    public function destroy(Request $request, $id)
    {
        try {
            $userToken = $request->query('user_token');

            $reply = DoubtReply::find($id);

            if (!$reply) {
                return response()->json([
                    'code' => 404,
                    'msg' => 'Reply not found'
                ], 404);
            }

            // Only allow deletion by the reply creator
            if ($reply->user_token !== $userToken) {
                return response()->json([
                    'code' => 403,
                    'msg' => 'Unauthorized - you can only delete your own replies'
                ], 403);
            }

            $reply->delete();

            return response()->json([
                'code' => 200,
                'msg' => 'Reply deleted successfully'
            ], 200);

        } catch (\Throwable $th) {
            return response()->json([
                'code' => 500,
                'msg' => 'Error deleting reply',
                'error' => $th->getMessage()
            ], 500);
        }
    }
}
