import { db } from "@workspace/database";
// import { users } from "@workspace/database";
import { NextResponse } from "next/server";

export async function GET() {
  // try {
  //   const allUsers = await db.select().from(users);

  //   return NextResponse.json({
  //     success: true,
  //     users: allUsers,
  //     total: allUsers.length,
  //   });
  // } catch (error) {
    // console.error("Error fetching users from Drizzle:", error);
    return NextResponse.json(
      {
        success: false,
        // error: error instanceof Error ? error.message : "Unknown error",
      },
      { status: 500 }
    );
  }
}
