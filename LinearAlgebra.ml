open Core.Std
open Array

module type MATRIX =
sig 
  
  (* our abstract type *)
  type m

  (* takes the transpose of the matrix but effectively swapping the "i" and 
   * and "j" coordinates of all elements in our matrix, given by 
   * array.(i).(j). used primarily in Massey's ranking algorithm.
   * can operate on any nxm matrix, but we'll only be using it for 
   * square matrices *)
  val transpose: m -> m

  (* multiplies two matrices for use in each of our ranking algorithms. 
   * most of our ranking algorithms will only require a matrix times a vector,
   * which is a matrix with 1-column. Massey's algorithm, though, will require 
   * us to multiply two nxn matrices *)
  val multiply: m -> m -> m

  (* as an alternative to invert, we'll implement the functionality for
   * row_reduce if we find some meta problems in inverting a matrix. we might
   * run into problems with trying to invert non-invertible matrices, but we're 
   * not yet sure if we'll ever be passing in matrices for which the determinant
   * is equal to 0. we'll meet with faculty in the math department to discuss 
   * this week *)
  val echelon: m -> m

  (* augments a matrix by a vector for use in row reducing (using echelon) *)
  val augment: m -> m -> m

  (* for use in recurring over base cases *)
  val empty_matrix: unit -> m

  (* for use in recurring over base cases *)
  val empty_float_array: unit -> m

  (* appends two float array arrays together during recursion/iteration *)
  val append: m -> m -> m

  (* turns a float into a float array array by appending float with empty
   * float array array *)
  val fill: float -> m

  (* makes a matrix given x and y dimensions & initial fill value *)
  val make_matrix: int -> int -> float -> m

  (* locates an element in a matrix and replaces it with a different float *)
  val fix_elt: m -> int -> int -> float -> unit

  (* locates an element in a matrix *)
  val find_elt: m -> int -> int -> float 

  (* length of a matrix (in other words --> the number of arrays in a matrix *)
  val matrix_length: m -> int

  (* length of an array, specifically within a matrix *)
  val array_length: m -> int

  (* imitates Array.init *)
  val init: int -> (int -> 'a) -> 'a array

  (* for locating entire arrays within a matrix *)
  val choose_array: m -> int -> float list
 
end


module Matrix : MATRIX =
struct

  open Array

  type m = float array array
  
  let empty_matrix () = [|[||]|]
  let empty_float_array () = [||]
  let append m1 m2 = Array.append m1 m2
  let fill float = [|[|float|]|]
  let make_matrix dim1 dim2 f = Array.make_matrix dim1 dim2 f
  let fix_elt matrix i j replacement = matrix.(i).(j) <- replacement
  let find_elt matrix i j = matrix.(i).(j)
  let matrix_length matrix = Array.length matrix
  let array_length matrix = Array.length matrix.(0)
  let init int func = Array.init int func 
  let choose_array matrix i : float list = 
    Array.to_list matrix.(i)

  (* if i is the index of the row and j is the index of the column, transpose 
   takes the (i,j) element and moves it to the (j,i) position of a new matrix. The 
   result is a new matrix that is the transpose of the original*)
  let transpose (matrix : m) : m  =  
    let new_height = Array.length matrix.(0) in
    let new_width = Array.length matrix in
    let new_matrix = (Array.make_matrix ~dimx:new_height ~dimy:new_width 1.) in
    let rec ihelper (c : int) : m =
      let rec jhelper (c2 : int) : m =
	Array.set new_matrix.(c) c2 matrix.(c2).(c);
	if c2 < new_width-1 then jhelper (c2 + 1)
	else ihelper (c + 1) in
      if c < new_height then jhelper (0)
      else new_matrix in
    ihelper (0)

  (* takes two rows of a matrix and swaps their position within the matrix *)
  let swap_rows m i j =
    let tmp = m.(i) in
    m.(i) <- m.(j);
    m.(j) <- tmp

  (* puts an additional column onto a matrix. Known as augmenting a matrix.
     each final column element is the sum of all the variables in the matrix row*)
  let augment (matrix : m) (vector : m) : m =
    let len = Array.length matrix.(0) in 
    let new_matrix = Array.make_matrix ~dimx:(len) ~dimy:(len + 1) 0. in
    for i = 0 to len-1 do
      new_matrix.(i) <- append matrix.(i) vector.(i)
    done;
    new_matrix
;;

(* takes two arrays and a function and outputs an array with with elements resulted
from the function and the two coresponding elements in the original array *)
let ericmap f xs ys =
  let n = Array.length xs in
  if Array.length ys <> n then raise (Invalid_argument "ericmap problems");
  Array.init n (fun i -> f xs.(i) ys.(i))
;;

(* multiplies two matrices by summing the ericmapped of two corresponding rows. One of the
matrices having been already transposed *)
let multiply (mat1 : m) (mat2 :m) : m =
  let tmat2 = transpose mat2 in
  let height = Array.length mat1 in
  let width = Array.length tmat2 in 
  let nmat = (Array.make_matrix ~dimx:(height) ~dimy:(width) 1.) in
  let rec column (c1 : float array) (c2 : float array) (cc : int) : m =
    let rec row (r1 : float array) (r2 : float array) (rc : int) : m = 
      Array.set nmat.(cc) rc (Array.fold_right ~f:(+.) (ericmap ( *. ) r1 r2) ~init:(0.));
      if rc < width-1 then row mat1.(cc) tmat2.(rc + 1) (rc+1)
      else column mat1.(cc) tmat2.(0) (cc+1) in
    if cc < height then row mat1.(cc) c2 0
    else nmat in
  column mat1.(0) tmat2.(0) (0)
;;

(* Takes a lead point and pivots around this to ensure that each row and column
has a single element as the number one and the remaining elements as zeros, or if necessary 
free elements  *)
let echelon (matx: m)  =
    let lead = ref 0
    and rows = Array.length matx
    and columns = Array.length matx.(0) in
    for r = 0 to rows - 1 do
      if columns <= !lead then
        raise Exit;
      let entry = ref r in
      while matx.(!entry).(!lead) = 0. do
        entry := !entry+1;
        if rows = !entry then begin
          entry := r;
          lead := !lead+1;
          if columns = !lead then
            raise Exit;
        end
      done;
      swap_rows matx !entry r;
      let part1 = matx.(r).(!lead) in
      matx.(r) <- Array.map (fun v -> v /. part1) matx.(r);
      for entry = 0 to rows-1 do
        if entry <> r then
          let part2 = matx.(entry).(!lead) in
          matx.(entry) <- Array.mapi (fun a b -> b -. part2 *. matx.(r).(a)) matx.(entry);
      done;
      lead := !lead+1;
    done;
    matx
 
end

(* tests all of our functions *)
let tests () = 
  let float_m = Matrix.fill 0. in
  let float_m1 = Matrix.fill 123. in
  assert(Matrix.find_elt float_m 0 0 = 0.);
  assert(Matrix.find_elt float_m1 0 0 = 123.);
  let m_row1 = Matrix.make_matrix 1 2 0. in
  let m_row2 = Matrix.make_matrix 1 2 0. in
  let m_2by2 = Matrix.append m_row1 m_row2 in
  assert(Matrix.matrix_length m_2by2 = 2);
  assert(Matrix.array_length m_2by2 = 2);
  assert(Matrix.find_elt m_2by2 0 0 = 0.);
  assert(Matrix.find_elt m_2by2 0 1 = 0.);
  assert(Matrix.find_elt m_2by2 1 0 = 0.);
  assert(Matrix.find_elt m_2by2 1 1 = 0.);
  assert(Matrix.fix_elt m_2by2 0 0 5.;
	 Matrix.find_elt m_2by2 0 0 = 5.);
  assert(Matrix.fix_elt m_2by2 1 1 10.;
	 Matrix.find_elt m_2by2 1 1 = 10.);
  let m_2by2 = Matrix.transpose m_2by2 in
  assert(Matrix.matrix_length m_2by2 = 2);
  assert(Matrix.array_length m_2by2 = 2);
  assert(Matrix.find_elt m_2by2 0 0 = 5.);
  assert(Matrix.find_elt m_2by2 0 1 = 0.);
  assert(Matrix.find_elt m_2by2 1 0 = 0.);
  assert(Matrix.find_elt m_2by2 1 1 = 10.);
  Matrix.fix_elt m_2by2 0 1 2.;
  Matrix.fix_elt m_2by2 1 0 6.;
  let t_2by2 = Matrix.transpose m_2by2 in
  assert(Matrix.find_elt t_2by2 0 0 = 5.);
  assert(Matrix.find_elt t_2by2 0 1 = 6.);
  assert(Matrix.find_elt t_2by2 1 0 = 2.);
  assert(Matrix.find_elt t_2by2 1 1 = 10.);
  let m2_2x2 = Matrix.make_matrix 2 2 0. in
  Matrix.fix_elt m2_2x2 0 0 1.;
  Matrix.fix_elt m2_2x2 0 1 2.;
  Matrix.fix_elt m2_2x2 1 0 3.;
  Matrix.fix_elt m2_2x2 1 1 4.;
  let m3_2x2 = Matrix.multiply m_2by2 m2_2x2 in
  assert(Matrix.find_elt m3_2x2 0 0 = 11.);
  assert(Matrix.find_elt m3_2x2 0 1 = 18.);
  assert(Matrix.find_elt m3_2x2 1 0 = 36.);
  assert(Matrix.find_elt m3_2x2 1 1 = 52.);
  let m3_2x2 = Matrix.multiply m2_2x2 m_2by2 in
  assert(Matrix.find_elt m3_2x2 0 0 = 17.);
  assert(Matrix.find_elt m3_2x2 0 1 = 22.);
  assert(Matrix.find_elt m3_2x2 1 0 = 39.);
  assert(Matrix.find_elt m3_2x2 1 1 = 46.);
  let reduced_m3 = Matrix.echelon m3_2x2 in
  assert(Matrix.find_elt reduced_m3 0 0 = 1.);
  assert(Matrix.find_elt reduced_m3 0 1 = 0.);
  assert(Matrix.find_elt reduced_m3 1 0 = 0.);
  assert(Matrix.find_elt reduced_m3 1 1 = 1.);;

tests ();;
